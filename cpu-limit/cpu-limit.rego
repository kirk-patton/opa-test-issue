package kubernetes.admission        


applicable_operations = {
    "CREATE",
    "UPDATE",
}

kinds = {
    "Deployment",
    "Statefulset",
    "Job",
}

deny[msg]  {
    applicable_operations[input.request.operation]
    kinds[input.request.kind.kind]
    container_name := input.request.object.spec.template.spec.containers[_].name
    containers := input.request.object.spec.template.spec.containers[_]
    not containers.resources.limits.cpu
    name := input.request.object.metadata.name 
    namespace := input.request.object.metadata.namespace
    msg = sprintf("DENY: missing spec.containers[].resources.limits.cpu %s/%s container: %s",[namespace,name,container_name])
}
