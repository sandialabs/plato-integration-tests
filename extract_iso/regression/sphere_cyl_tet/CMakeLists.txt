

set(exec "extract_iso")
set(infile1 "sphere_cyl_level_set_tet_0.0.exo")
set(gold_outfile1 "sphere_cyl_level_set_tet_0.0_np4_gold.exo")
set(gold_outfile1_isoonly "sphere_cyl_level_set_tet_0.0_np4_iso_only_gold.exo")
set(outfile1 "sphere_cyl_level_set_tet_0.0_np4.exo")
set(fieldname "level_set")
set(isovalue "0.0")
set(minedgelength "1e-5")
set(levelsetdata "1")
set(output_method "0")
set(readspreadfile "0") 
set(tolerancefile "../tolerances.txt")
set(noinput "True")

set( testFiles ${infile1} ${tolerancefile} ${gold_outfile1} ${gold_outfile1_isoonly})
Plato_add_test_files( "${testFiles}" )

Plato_new_test(BASE_TEST_NAME)
set( IO_COMM_INDEX 0 )

set(NumProcs "4")
set(isoonly "0")
set(TEST_NAME "${BASE_TEST_NAME}_${NumProcs}")
set(gold_file ${gold_outfile1})
create_extract_iso_test(${gold_file})

set(NumProcs "4")
set(isoonly "1")
set(TEST_NAME "${BASE_TEST_NAME}_${NumProcs}_isoonly")
set(gold_file ${gold_outfile1_isoonly})
create_extract_iso_test(${gold_file})
