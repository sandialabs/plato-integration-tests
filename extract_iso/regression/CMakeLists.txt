function(create_extract_iso_test gold_file)
set( RUN_COMMAND "mpirun -n ${NumProcs} ${exec} --in_mesh=${infile1} --out_mesh=${outfile1} --field_name=${fieldname} \
    --iso_value=${isovalue} --min_edge_length=${minedgelength} --level_set_data=${levelsetdata} --iso_only=${isoonly} \
    --output_method=${output_method} --read_spread_file=${readspreadfile}" )
Plato_add_test(${RUN_COMMAND} ${TEST_NAME} ${NumProcs} ${IO_COMM_INDEX} ${tolerancefile} ${gold_file} ${infile1} ${outfile1})
set_property(TEST ${TEST_NAME} PROPERTY LABELS "small")
endfunction()

add_subdirectory(example1)
add_subdirectory(example2)
add_subdirectory(example3)
add_subdirectory(mitchell)
add_subdirectory(cube_cube_tet)
add_subdirectory(cube_sphere_tet)
add_subdirectory(sphere_cyl_tet)
