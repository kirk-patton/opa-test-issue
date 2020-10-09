package kubernetes.admission

# Check for non Deployment resource
test_not_deployment_kind {

    testInput := {
    	"request": {
    		"kind": {
    			"kind": "Pod"
    		},
    		"operation": "UPDATE",
    		"object": {
    			"metadata": {
    				"name": "deployName",
    				"namespace": "nsName"
    			},
    			"spec": {
    				"template": {
    					"spec": {
    						"containers": [{
    							"name": "ctrName",
    							"livenessProbe": {
    								"failureThreshold": 1
    							}
    						}]
    					}
    				}
    			}
    		}
    	}
    }
    count(deny) = 0 with input as testInput
}

# Check for non CREATE or UPDATE resource operations
test_not_applicable_op {

    testInput := {
    	"request": {
    		"kind": {
    			"kind": "Deployment"
    		},
    		"operation": "DELETE",
    		"object": {
    			"metadata": {
    				"name": "deployName",
    				"namespace": "nsName"
    			},
    			"spec": {
    				"template": {
    					"spec": {
    						"containers": [{
    							"name": "ctrName",
    							"livenessProbe": {
    								"failureThreshold": 1
    							}
    						}]
    					}
    				}
    			}
    		}
    	}
    }
    count(deny) = 0 with input as testInput
}

# Check for a correct Deployment spec
test_positive_case {

    testInput := {
    	"request": {
    		"kind": {
    			"kind": "Deployment"
    		},
    		"operation": "CREATE",
    		"object": {
    			"metadata": {
    				"name": "deployName",
    				"namespace": "nsName"
    			},
    			"spec": {
    				"template": {
    					"spec": {
    						"containers": [{
    							"name": "ctrName",
    							"livenessProbe": {
    								"failureThreshold": 3
    							},
    							"readinessProbe": {
    								"failureThreshold": 3
    							}
    						}]
    					}
    				}
    			}
    		}
    	}
    }
    count(deny) = 0 with input as testInput
}

# Check for a Deployment spec with a container with livenessProbe failureThreshold=1
test_negative_case_1 {

    testInput := {
    	"request": {
    		"kind": {
    			"kind": "Deployment"
    		},
    		"operation": "UPDATE",
    		"object": {
    			"metadata": {
    				"name": "deployName",
    				"namespace": "nsName"
    			},
    			"spec": {
    				"template": {
    					"spec": {
    						"containers": [{
    							"name": "ctrName",
    							"livenessProbe": {
    								"failureThreshold": 1
    							}
    						}]
    					}
    				}
    			}
    		}
    	}
    }
    deny = {"nsName/deployName: failureThreshold for readinessProbe and livenessProbe should be greater than 1 for container ctrName"} with input as testInput
}

# Check for a Deployment spec with multiple containers with probes failureThreshold=1
test_negative_case_2 {

    testInput := {
    	"request": {
    		"kind": {
    			"kind": "Deployment"
    		},
    		"operation": "CREATE",
    		"object": {
    			"metadata": {
    				"name": "deployName",
    				"namespace": "nsName"
    			},
    			"spec": {
    				"template": {
    					"spec": {
    						"containers": [{
    								"name": "ctrName",
    								"livenessProbe": {
    									"failureThreshold": 1
    								}
    							},
    							{
    								"name": "ctrName2",
    								"readinessProbe": {
    									"failureThreshold": 1
    								}
    							}
    						]
    					}
    				}
    			}
    		}
    	}
    }
    deny = {
            "nsName/deployName: failureThreshold for readinessProbe and livenessProbe should be greater than 1 for container ctrName",
            "nsName/deployName: failureThreshold for readinessProbe and livenessProbe should be greater than 1 for container ctrName2"
    } with input as testInput
}