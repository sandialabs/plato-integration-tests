

set(exec "extract_iso")
set(infile1 "example3.exo")
set(gold_outfile1 "example3_np8.gold.exo")
set(outfile1 "example3_np1.exo")
set(fieldname "LSD")
set(isovalue "0")
set(minedgelength "1e-5")
set(levelsetdata "0")
set(isoonly "0")
set(output_method "0")
set(readspreadfile "0") 
set(tolerancefile "../tolerances.txt")
set(noinput "True")

set( testFiles ${infile1} ${tolerancefile} ${gold_outfile1})
Plato_add_test_files( "${testFiles}" )

Plato_new_test(BASE_TEST_NAME)
set( IO_COMM_INDEX 0 )

set(NumProcs "8")
set(TEST_NAME "${BASE_TEST_NAME}_${NumProcs}")
create_extract_iso_test(${gold_outfile1})

set(NumProcs "1")
set(TEST_NAME "${BASE_TEST_NAME}_${NumProcs}")
create_extract_iso_test(${gold_outfile1})
