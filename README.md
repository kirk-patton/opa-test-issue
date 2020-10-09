# opa-test-issue
Test failure

## Summary

When running opa test -v within each policy directory, they pass.  When running from their parent 
directory, the pro-failure-threshold directory has three failures.

Prior to adding the cpu-limit policy, the tests within the probe-failure-threshold directory passed.

```
.
├── README.md
├── cpu-limit
│   ├── cpu-limit.rego
│   └── cpu-limit_test.rego
└── probe-failure-threshold
    ├── probe-failure-threshold.rego
    └── probe-failure-threshold_test.rego

```

```
>opa test -v .
FAILURES
--------------------------------------------------------------------------------
data.kubernetes.admission.test_positive_case: FAIL (438.62µs)

  query:1                                                          Enter data.kubernetes.admission.test_positive_case = _
  probe-failure-threshold/probe-failure-threshold_test.rego:68     | Enter data.kubernetes.admission.test_positive_case
  cpu-limit/cpu-limit.rego:15                                      | | Enter data.kubernetes.admission.deny
  cpu-limit/cpu-limit.rego:20                                      | | | Enter containers.resources.limits.cpu
  cpu-limit/cpu-limit.rego:20                                      | | | | Fail containers.resources.limits.cpu
  probe-failure-threshold/probe-failure-threshold.rego:13          | | Enter data.kubernetes.admission.deny
  probe-failure-threshold/probe-failure-threshold.rego:16          | | | Fail lt(__local25__, 2)
  probe-failure-threshold/probe-failure-threshold.rego:16          | | | Fail lt(__local25__, 2)
  probe-failure-threshold/probe-failure-threshold_test.rego:99     | | Fail __local19__ = 0 with input as testInput
  query:1                                                          | Fail data.kubernetes.admission.test_positive_case = _

data.kubernetes.admission.test_negative_case_1: FAIL (567.585µs)

  query:1                                                           Enter data.kubernetes.admission.test_negative_case_1 = _
  probe-failure-threshold/probe-failure-threshold_test.rego:103     | Enter data.kubernetes.admission.test_negative_case_1
  cpu-limit/cpu-limit.rego:15                                       | | Enter data.kubernetes.admission.deny
  cpu-limit/cpu-limit.rego:20                                       | | | Enter containers.resources.limits.cpu
  cpu-limit/cpu-limit.rego:20                                       | | | | Fail containers.resources.limits.cpu
  probe-failure-threshold/probe-failure-threshold.rego:13           | | Redo data.kubernetes.admission.deny
  probe-failure-threshold/probe-failure-threshold.rego:16           | | | Fail __local25__ = input.request.object.spec.template.spec.containers[_][__local24__].failureThreshold
  probe-failure-threshold/probe-failure-threshold_test.rego:131     | | Fail data.kubernetes.admission.deny = {"nsName/deployName: failureThreshold for readinessProbe and livenessProbe should be greater than 1 for container ctrName"} with input as testInput
  query:1                                                           | Fail data.kubernetes.admission.test_negative_case_1 = _

data.kubernetes.admission.test_negative_case_2: FAIL (970.523µs)

  query:1                                                           Enter data.kubernetes.admission.test_negative_case_2 = _
  probe-failure-threshold/probe-failure-threshold_test.rego:135     | Enter data.kubernetes.admission.test_negative_case_2
  cpu-limit/cpu-limit.rego:15                                       | | Enter data.kubernetes.admission.deny
  cpu-limit/cpu-limit.rego:20                                       | | | Enter containers.resources.limits.cpu
  cpu-limit/cpu-limit.rego:20                                       | | | | Fail containers.resources.limits.cpu
  cpu-limit/cpu-limit.rego:15                                       | | Redo data.kubernetes.admission.deny
  cpu-limit/cpu-limit.rego:20                                       | | | Enter containers.resources.limits.cpu
  cpu-limit/cpu-limit.rego:20                                       | | | | Fail containers.resources.limits.cpu
  cpu-limit/cpu-limit.rego:15                                       | | Redo data.kubernetes.admission.deny
  cpu-limit/cpu-limit.rego:20                                       | | | Enter containers.resources.limits.cpu
  cpu-limit/cpu-limit.rego:20                                       | | | | Fail containers.resources.limits.cpu
  cpu-limit/cpu-limit.rego:15                                       | | Redo data.kubernetes.admission.deny
  cpu-limit/cpu-limit.rego:20                                       | | | Enter containers.resources.limits.cpu
  cpu-limit/cpu-limit.rego:20                                       | | | | Fail containers.resources.limits.cpu
  probe-failure-threshold/probe-failure-threshold_test.rego:170     | | Fail data.kubernetes.admission.deny = {"nsName/deployName: failureThreshold for readinessProbe and livenessProbe should be greater than 1 for container ctrName", "nsName/deployName: failureThreshold for readinessProbe and livenessProbe should be greater than 1 for container ctrName2"} with input as testInput
  query:1                                                           | Fail data.kubernetes.admission.test_negative_case_2 = _

SUMMARY
--------------------------------------------------------------------------------
data.kubernetes.admission.test_admission_has_no_cpu_limit: PASS (6.801892ms)
data.kubernetes.admission.test_admission_update_has_no_cpu_limit: PASS (995.805µs)
data.kubernetes.admission.test_admission_has_cpu_limit: PASS (235.406µs)
data.kubernetes.admission.test_not_deployment_kind: PASS (297.183µs)
data.kubernetes.admission.test_not_applicable_op: PASS (258.132µs)
data.kubernetes.admission.test_positive_case: FAIL (438.62µs)       <===================
data.kubernetes.admission.test_negative_case_1: FAIL (567.585µs)    <===================
data.kubernetes.admission.test_negative_case_2: FAIL (970.523µs)    <===================
--------------------------------------------------------------------------------
PASS: 5/8
FAIL: 3/8
```

## Each policy tested individually

```
>cd probe-failure-threshold/
>opa test -v .
data.kubernetes.admission.test_not_deployment_kind: PASS (589.731µs)
data.kubernetes.admission.test_not_applicable_op: PASS (238.457µs)
data.kubernetes.admission.test_positive_case: PASS (544.302µs)
data.kubernetes.admission.test_negative_case_1: PASS (410.206µs)
data.kubernetes.admission.test_negative_case_2: PASS (727.234µs)
--------------------------------------------------------------------------------
PASS: 5/5
```

```
>cd cpu-limit/
>opa test -v .
data.kubernetes.admission.test_admission_has_no_cpu_limit: PASS (930.784µs)
data.kubernetes.admission.test_admission_update_has_no_cpu_limit: PASS (449.725µs)
data.kubernetes.admission.test_admission_has_cpu_limit: PASS (195.762µs)
--------------------------------------------------------------------------------
PASS: 3/3
```

## After removal of the cpu-limit policy

>mv cpu-limit /tmp
>opa test -v .
data.kubernetes.admission.test_not_deployment_kind: PASS (591.051µs)
data.kubernetes.admission.test_not_applicable_op: PASS (234.208µs)
data.kubernetes.admission.test_positive_case: PASS (407.255µs)
data.kubernetes.admission.test_negative_case_1: PASS (385.486µs)
data.kubernetes.admission.test_negative_case_2: PASS (620.95µs)
--------------------------------------------------------------------------------
PASS: 5/5
