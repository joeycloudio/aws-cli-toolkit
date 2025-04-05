\# 🛠️ Karpenter CrashLoopBackOff Fix – EKS Integration (v1.3.3)

\## ⚠️ Problem

Karpenter controller kept crashing with this error:

AccessDenied: Not authorized to perform sts:AssumeRoleWithWebIdentity

yaml

Copy

Edit

Root cause: \*\*Karpenter’s IAM role did not have a proper trust policy.\*\* It couldn't assume its own role, so the controller failed to start.

\---

\## ✅ Solution

\### 1. Cleanup Bad Helm Releases & Resources

\`\`\`bash

helm uninstall karpenter -n karpenter || true

kubectl delete namespace karpenter || true

kubectl delete clusterrole karpenter || true

kubectl delete clusterrolebinding karpenter || true

kubectl delete crds -l app.kubernetes.io/name=karpenter || true

2\. Get OIDC Issuer

bash

Copy

Edit

aws eks describe-cluster \\

\--name eks-workshop \\

\--region eu-west-2 \\

\--query "cluster.identity.oidc.issuer" \\

\--output text

Example output:

bash

Copy

Edit

https://oidc.eks.eu-west-2.amazonaws.com/id/33168D7B2892552ACBA25B8C6E7F2025

3\. Add Trust Policy to Karpenter IAM Role

Update the trust relationship of the IAM role (KarpenterController-...) to:

json

Copy

Edit

{

"Version": "2012-10-17",

"Statement": \[

{

"Effect": "Allow",

"Principal": {

"Federated": "arn:aws:iam::273354636904:oidc-provider/oidc.eks.eu-west-2.amazonaws.com/id/33168D7B2892552ACBA25B8C6E7F2025"

},

"Action": "sts:AssumeRoleWithWebIdentity",

"Condition": {

"StringEquals": {

"oidc.eks.eu-west-2.amazonaws.com/id/33168D7B2892552ACBA25B8C6E7F2025:sub": "system:serviceaccount:kube-system:karpenter"

}

}

}

\]

}

You can apply this in the IAM Console or via aws iam update-assume-role-policy.

4\. Install Karpenter via Correct Helm Chart (v1.3.3)

bash

Copy

Edit

helm upgrade --install karpenter oci://public.ecr.aws/karpenter/karpenter \\

\--version "1.3.3" \\

\--namespace kube-system --create-namespace \\

\--set serviceAccount.annotations."eks\\.amazonaws\\.com/role-arn"="arn:aws:iam::273354636904:role/KarpenterController-..." \\

\--set settings.clusterName="eks-workshop" \\

\--set settings.clusterEndpoint="https://" \\

\--set settings.interruptionQueue="Karpenter-eks-workshop" \\

\--wait

5\. Validate It’s Running

bash

Copy

Edit

kubectl get pods -n kube-system | grep karpenter

Expected output:

sql

Copy

Edit

karpenter-xxxxx-xxxxx 1/1 Running

✅ Karpenter is now fully operational 🎉

vbnet

Copy

Edit

Let me know if you want this turned into a GitHub README or blog post version.
