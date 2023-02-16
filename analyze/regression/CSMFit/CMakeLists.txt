Requires_features(PLATOANALYZE_ENABLE_PYTHON PLATOANALYZE_ENABLE_GEOMETRY PLATOANALYZE_ENABLE_ESP)

set( testFiles "analyzeApp.xml;analyzeInput.xml;model.csm;opt.py;platoApp.xml;platoInput.xml;points.xyz")

Plato_add_test_files( "${testFiles}" )

Plato_new_test(TEST_NAME)

set( TEST_COMMAND "${Python3_EXECUTABLE} opt.py" )

Plato_add_single_test( ${TEST_COMMAND} ${TEST_NAME} )
