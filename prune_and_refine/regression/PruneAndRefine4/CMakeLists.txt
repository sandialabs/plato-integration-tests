set( INPUT_MESH "prune3.exo" )
set( OUTPUT_MESH "prune3_pruned.exo" )
set( FIELD_NAME "brett" )
set( NUM_PROCS 3 )
set( NUM_REFINES 0 )
set( PRUNE_MESH 1 )
set( NUM_BUFFER_LAYERS 0 )
set( IO_COMM_INDEX 0 )
Set_exodiff_files(EXODIFF_COMMAND_FILE EXODIFF_REFERENCE)

set( testFiles ${INPUT_MESH} ${EXODIFF_COMMAND_FILE} ${EXODIFF_REFERENCE} )
Plato_add_test_files( "${testFiles}" )

Plato_new_test(TEST_NAME)

set( RUN_COMMAND "mpirun -n ${NUM_PROCS} prune_and_refine --mesh_with_variable=${INPUT_MESH} --mesh_to_be_pruned=${INPUT_MESH} --result_mesh=${OUTPUT_MESH} --field_name=${FIELD_NAME} --number_of_refines=${NUM_REFINES} --number_of_buffer_layers=${NUM_BUFFER_LAYERS} --prune_mesh=${PRUNE_MESH}" )

Plato_add_test(${RUN_COMMAND} ${TEST_NAME} ${NUM_PROCS} ${IO_COMM_INDEX} ${EXODIFF_COMMAND_FILE} ${EXODIFF_REFERENCE} ${INPUT_MESH} ${OUTPUT_MESH})

