Fixing Karpenter CrashLoopBackOff on EKS
========================================

SUMMARY:Karpenter was crashing because its IAM role didn’t have a valid trust policy to allow the Kubernetes controller to assume it via OIDC. We’ll clean up everything, fix the trust policy, and reinstall using the official Karpenter Helm chart from ECR.

Step 1 – CLEAN UP old resources (if any):

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   bashCopyEdithelm uninstall karpenter -n karpenter || true  kubectl delete namespace karpenter || true  kubectl delete clusterrole karpenter || true  kubectl delete clusterrolebinding karpenter || true  kubectl delete crds -l app.kubernetes.io/name=karpenter || true   `

Step 2 – GET the OIDC Provider for your cluster:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   bashCopyEditaws eks describe-cluster \    --name eks-workshop \    --region eu-west-2 \    --query "cluster.identity.oidc.issuer" \    --output text   `

Example output:[https://oidc.eks.eu-west-2.amazonaws.com/id/33168D7B2892552ACBA25B8C6E7F2025](https://oidc.eks.eu-west-2.amazonaws.com/id/33168D7B2892552ACBA25B8C6E7F2025)

You’ll need that ID string at the end.

Step 3 – FIX the IAM trust policy for KarpenterController role:

Go into IAM > Roles > KarpenterController... and update the trust relationship to:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   jsonCopyEdit{    "Version": "2012-10-17",    "Statement": [      {        "Effect": "Allow",        "Principal": {          "Federated": "arn:aws:iam::273354636904:oidc-provider/oidc.eks.eu-west-2.amazonaws.com/id/33168D7B2892552ACBA25B8C6E7F2025"        },        "Action": "sts:AssumeRoleWithWebIdentity",        "Condition": {          "StringEquals": {            "oidc.eks.eu-west-2.amazonaws.com/id/33168D7B2892552ACBA25B8C6E7F2025:sub": "system:serviceaccount:kube-system:karpenter"          }        }      }    ]  }   `

That’s what allows the controller pod to assume the role via IAM.

Step 4 – INSTALL Karpenter using the correct official Helm chart:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   bashCopyEdithelm upgrade --install karpenter oci://public.ecr.aws/karpenter/karpenter \    --version "1.3.3" \    --namespace kube-system --create-namespace \    --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"="arn:aws:iam::273354636904:role/KarpenterController-20250405014125772500000013" \    --set settings.clusterName="eks-workshop" \    --set settings.clusterEndpoint="https://33168D7B2892552ACBA25B8C6E7F2025.gr7.eu-west-2.eks.amazonaws.com" \    --set settings.interruptionQueue="Karpenter-eks-workshop" \    --wait   `

This uses the new OCI-based Helm chart source, not the legacy one.

Step 5 – VERIFY it's working:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   bashCopyEditkubectl get pods -n kube-system | grep karpenter   `

Expected result:karpenter-xxxxxxxxxxxx 1/1 Running 0 XXs

If it’s still crashing, run:

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   bashCopyEditkubectl logs -n kube-system deploy/karpenter -c controller   `

If the logs say AccessDenied or CLUSTER\_NAME is required, your trust policy or Helm settings are still broken. Recheck the ARN and values.

FAQ – What is a controller?

A controller in Kubernetes is a background process that watches resources (like nodes or pods) and makes sure the actual state matches the desired state. Karpenter's controller looks at pending pods and automatically provisions new nodes based on demand.
