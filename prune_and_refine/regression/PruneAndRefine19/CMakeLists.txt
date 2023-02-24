set( MESH_WITH_VARIABLE "restart_100.exo" )
set( MESH_TO_BE_PRUNED "start_mesh4.gen" )
set( OUTPUT_MESH "pruned.exo" )
set( RESTART_MESH ${MESH_TO_BE_PRUNED} )
set( FIELD_NAME "optimizationdofs" )
set( NUM_PROCS 5 )
set( NUM_REFINES 0 )
set( PRUNE_MESH 0 )
set( NUM_BUFFER_LAYERS 0 )
set( IO_COMM_INDEX 0 )
Set_exodiff_files(EXODIFF_COMMAND_FILE EXODIFF_REFERENCE)

set( testFiles ${MESH_WITH_VARIABLE} ${MESH_TO_BE_PRUNED} ${EXODIFF_COMMAND_FILE} ${EXODIFF_REFERENCE} )
Plato_add_test_files( "${testFiles}" )

Plato_new_test(TEST_NAME)

set( RUN_COMMAND "mpirun -n ${NUM_PROCS} prune_and_refine --mesh_with_variable=${MESH_WITH_VARIABLE} --mesh_to_be_pruned=${MESH_TO_BE_PRUNED} --result_mesh=${OUTPUT_MESH} --field_name=${FIELD_NAME} --number_of_refines=${NUM_REFINES} --number_of_buffer_layers=${NUM_BUFFER_LAYERS} --prune_mesh=${PRUNE_MESH}" )

#Plato_add_serial_test( ${TEST_COMMAND} ${TEST_NAME} ${OUTPUT_MESH} )
Plato_add_test(${RUN_COMMAND} ${TEST_NAME} ${NUM_PROCS} ${IO_COMM_INDEX} ${EXODIFF_COMMAND_FILE} ${EXODIFF_REFERENCE} ${MESH_WITH_VARIABLE} ${OUTPUT_MESH} ${RESTART_MESH})

