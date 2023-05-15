local kap = import 'lib/kapitan.libjsonnet';
local inv = kap.inventory();
local params = inv.parameters.storage_local_static;
local argocd = import 'lib/argocd.libjsonnet';

local app = argocd.App('storage-local-static', params.namespace);

{
  'storage-local-static': app,
}
