begin level_set_topology
    mesh_name cylinder.exo
    output_name level-set-result.exo
    include_void_region true
    sphere_pattern radius 2.5 spacing 5 min (-10,-10,-1) max (10,10,1)
    level_set_bounds [-1, 1]
    fixed_blocks fixed_block
end

begin kernel_filter
    filter_radius 2
    use_relative_radius true
    centering_type node
end

begin objective thermal_compliance
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_thermal_compliance.xml
    aggregation_weight 1e-6 
end

begin objective volume_obj
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_volume.xml
    aggregation_weight 1 
end

begin rol_optimization
    max_iterations 5
end
