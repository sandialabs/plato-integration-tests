
# Sets the number of OpenMP threads to use for a test, based on PLATOANALYZE_ENABLE_OPENMP
function(set_num_threads_for_test OUT_NUM_THREADS)

set( ${OUT_NUM_THREADS} "1" PARENT_SCOPE)
if( PLATOANALYZE_ENABLE_OPENMP )
    set( ${OUT_NUM_THREADS} "8" PARENT_SCOPE)
endif()

endfunction(set_num_threads_for_test)
