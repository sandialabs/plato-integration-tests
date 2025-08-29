begin level_set_topology
    mesh_name lbracket-two-block.exo
    output_name level-set-result.exo
    include_void_region true
    sphere_pattern_bbox_min_x 0
    sphere_pattern_bbox_min_y 0
    sphere_pattern_bbox_min_z 0
    sphere_pattern_bbox_max_x 0
    sphere_pattern_bbox_max_y 0
    sphere_pattern_bbox_max_z 0
    sphere_pattern_radius 0.25
    sphere_pattern_spacing 0.75
    level_set_lower_bound -1
    level_set_upper_bound 1
    fixed_blocks block_1
end

begin kernel_filter
    filter_radius 2
    centering_type node
    use_relative_radius true
end

begin objective mass_properties
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_mass_properties.xml
    aggregation_weight 1000
end

begin rol_optimization
    max_iterations 3
    approximate_hessian true
    initial_search_radius 20
end
