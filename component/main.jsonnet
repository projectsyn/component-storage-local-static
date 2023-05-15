// main template for storage-local-static
local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
local sc = import 'lib/storageclass.libsonnet';
local inv = kap.inventory();
// The hiera parameters for the component
local params = inv.parameters.storage_local_static;

local namespace = kube.Namespace(params.namespace) {
  metadata+: {
    annotations+: {
      'openshift.io/node-selector': '',
    },
    labels+: {
      'app.kubernetes.io/name': params.namespace,
      // Configure the namespaces so that the OCP4 cluster-monitoring
      // Prometheus can find the servicemonitors and rules.
      'openshift.io/cluster-monitoring': 'true',
    },
  },
};

local StorageClass(name='ssd-local') = sc.storageClass(name) {
  metadata+: {
    labels+: {
      'app.kubernetes.io/name': 'local-volume-provisioner',
      'app.kubernetes.io/instance': 'local-volume-provisioner',
    },
  },
  provisioner: 'kubernetes.io/no-provisioner',
  volumeBindingMode: 'WaitForFirstConsumer',
  [if std.objectHas(params.storageClasses[name], 'reclaimPolicy') then 'reclaimPolicy']: params.storageClasses[name].reclaimPolicy,
};

// Define outputs below
{
  '00_namespace': namespace,
  '22_storage_classes': [
    StorageClass(name)
    for name in std.objectFields(params.storageClasses)
  ],
}
