package kubernetes.admission

test_admission_has_no_cpu_limit {
  testInput := {
	"kind": "AdmissionReview",
	"apiVersion": "admission.k8s.io/v1beta1",
	"request": {
		"kind": {
			"group": "extensions",
			"version": "v1beta1",
			"kind": "Deployment"
		},
		"namespace": "our-namespace",
		"operation": "CREATE",
		"object": {
			"apiVersion": "extensions/v1beta1",
			"kind": "Deployment",
			"metadata": {
				"name": "policy-test",
				"namespace": "kube-mgmt"
			},
			"spec": {
			"template": {
				"spec": {
					"containers": [{
                  "name": "test",
						"resources": {}
					}]
				}
			}
         }
		}
	}
}
   expected := "DENY: missing spec.containers[].resources.limits.cpu kube-mgmt/policy-test container: test"
   deny[expected] with input as testInput
}

test_admission_update_has_no_cpu_limit {
  testInput := {
	"kind": "AdmissionReview",
	"apiVersion": "admission.k8s.io/v1beta1",
	"request": {
		"kind": {
			"group": "extensions",
			"version": "v1beta1",
			"kind": "Deployment"
		},
		"namespace": "our-namespace",
		"operation": "UPDATE",
		"object": {
			"apiVersion": "extensions/v1beta1",
			"kind": "Deployment",
			"metadata": {
				"name": "policy-test",
				"namespace": "kube-mgmt"
			},
			"spec": {
			"template": {
				"spec": {
					"containers": [{
                  "name": "test",
						"resources": {}
					}]
				}
			}
         }
		}
	}
}
   expected := "DENY: missing spec.containers[].resources.limits.cpu kube-mgmt/policy-test container: test"
   deny[expected] with input as testInput
}

test_admission_has_cpu_limit {
  testInput := {
      "kind": "AdmissionReview",
      "apiVersion": "admission.k8s.io/v1beta1",
      "request": {
         "namespace": "our-namespace",
         "kind": {
            "group": "batch",
            "version": "v1",
            "kind": "Deployment"
         },
         "metadata": {
            "name": "sample-omega-cronjob-1601925300",
            "ownerReferences": [{
               "name": "sample-omega-cronjob"
            }]
         },
         "operation": "CREATE",
         "object": {
            "apiVersion": "batch/v1",
            "kind": "Deployment",
            "spec": {
               "template": {
                  "spec": {
                     "containers": [{
                        "resources": {
                           "limits": {
                              "cpu": "1m"
                           }
                        }
                     }]
                  }
               }
            }
         }
      }
   }
   count(deny) == 0 with input as testInput
}

