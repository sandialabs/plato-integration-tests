Requires_features( LEGACY_BUILD )

set(NumProcs "2") 
set(exec "extract_iso")
set(infile1 "two_block_example1.exo")
set(gold_outfile1 "two_block_example1_np2_1.gold.exo")
set(outfile1 "two_block_example1_np2_1.exo")
set(fieldname "LSD")
set(isovalue "0.5")
set(minedgelength "1e-3")
set(levelsetdata "0")
set(isoonly "0")
set(output_method "0")
set(readspreadfile "0") 
set(tolerancefile "../tolerances.txt")
set(noinput "True")

set( testFiles ${infile1} ${tolerancefile} ${gold_outfile1})
Plato_add_test_files( "${testFiles}" )

Plato_new_test(TEST_NAME)
set( IO_COMM_INDEX 0 )

set( RUN_COMMAND "mpirun -n ${NumProcs} ${exec} --in_mesh=${infile1} --out_mesh=${outfile1} --field_name=${fieldname} \
    --iso_value=${isovalue} --min_edge_length=${minedgelength} --level_set_data=${levelsetdata} --iso_only=${isoonly} \
    --output_method=${output_method} --read_spread_file=${readspreadfile}" )

Plato_add_test(${RUN_COMMAND} ${TEST_NAME} ${NumProcs} ${IO_COMM_INDEX} ${tolerancefile} ${gold_outfile1} ${infile1} ${outfile1})
set_property(TEST ${TEST_NAME} PROPERTY LABELS "small")
