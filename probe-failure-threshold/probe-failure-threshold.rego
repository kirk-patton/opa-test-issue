package kubernetes.admission

applicable_operations = {
    "CREATE",
    "UPDATE",
}

probes = {
    "livenessProbe",
    "readinessProbe"
}

deny[msg] {
    input.request.kind.kind = "Deployment"
    applicable_operations[input.request.operation]
    input.request.object.spec.template.spec.containers[_][probes[_]].failureThreshold < 2
    msg = sprintf("%s/%s: failureThreshold for readinessProbe and livenessProbe should be greater than 1 for container %s", [input.request.object.metadata.namespace, input.request.object.metadata.name, input.request.object.spec.template.spec.containers[_].name])
}
