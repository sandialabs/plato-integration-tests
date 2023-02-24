Set_exodiff_files(EXODIFF_COMMAND_FILE EXODIFF_REFERENCE)
set( testFiles  "prune1.exo" ${EXODIFF_COMMAND_FILE} ${EXODIFF_REFERENCE} )
Plato_add_test_files( "${testFiles}" )

Plato_new_test(TEST_NAME)

set( INPUT_MESH "prune1.exo" )
set( OUTPUT_MESH "prune1_pruned.exo" )
set( NUM_PROCS 2 )
set( IO_COMM_INDEX 0 )

set( RUN_COMMAND "mpirun -n ${NUM_PROCS} prune_and_refine --mesh_with_variable=prune1.exo --mesh_to_be_pruned=prune1.exo --result_mesh=prune1_pruned.exo --field_name=brett --number_of_refines=0 --number_of_buffer_layers=0 --prune_mesh=1" )

Plato_add_test(${RUN_COMMAND} ${TEST_NAME} ${NUM_PROCS} ${IO_COMM_INDEX} ${EXODIFF_COMMAND_FILE} ${EXODIFF_REFERENCE} ${INPUT_MESH} ${OUTPUT_MESH})

