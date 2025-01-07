local kap = import 'lib/kapitan.libjsonnet';
local inv = kap.inventory();
local params = inv.parameters.storage_local_static;
local argocd = import 'lib/argocd.libjsonnet';

local app = argocd.App('storage-local-static', params.namespace);

local appPath =
  local project = std.get(std.get(app, 'spec', {}), 'project', 'syn');
  if project == 'syn' then 'apps' else 'apps-%s' % project;

{
  ['%s/storage-local-static' % appPath]: app,
}
