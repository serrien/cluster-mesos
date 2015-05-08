name "consul"
run_list("recipe[cluster-mesos::mesos_slave]")