%builtins output range_check

from treemap import TreeMap
from treemap import KeyValue
from treemap import Result
from treemap import map_to_list
from treemap import list_to_map
from treemap import empty
from treemap import put
from treemap import get
from treemap import get_or_default
from treemap import output_treemap

# "Tests" insert and lookup
func main(output_ptr : felt*, range_check_ptr) -> (output_ptr : felt*, range_check_ptr):
    alloc_locals
    let (map) = empty()
    let (range_check_ptr, map) = put(range_check_ptr, 2, 22, map) # 2->22
    let (range_check_ptr, map) = put(range_check_ptr, 3, 32, map) # 2->22, 3->32
    let (range_check_ptr, map) = put(range_check_ptr, 4, 44, map) # 2->22, 3->32, 4->44
    let (range_check_ptr, map) = put(range_check_ptr, 3, 33, map) # 2->22, 3->33, 4->44
    let (local range_check_ptr, local map: TreeMap*) = put(range_check_ptr, 1, 11, map) # 1->11, 2->22, 3->33, 4->44

    let (local output_ptr: felt*) = output_treemap(output_ptr, map)

    let (range_check_ptr, res: Result*) = get(range_check_ptr, 2, map) 
    assert res.value = 22

    let (range_check_ptr, res: Result*) = get(range_check_ptr, 3, map)
    assert res.value = 33

    let (range_check_ptr, res: Result*) = get(range_check_ptr, 5, map)
    assert res.empty = 1

    let (range_check_ptr, value: felt) = get_or_default(range_check_ptr, 5, -1, map)
    assert value = -1

    #TODO: Test roundtrip
    #let (list, length) = map_to_list(map)
    #let (recreated_map) = list_to_map(list, length)

    return(output_ptr=output_ptr, range_check_ptr=range_check_ptr)
end

#> cairo-compile treemap_test.cairo --output treemap_test_compiled.json && cairo-run --program=treemap_test_compiled.json --print_output --layout=small
