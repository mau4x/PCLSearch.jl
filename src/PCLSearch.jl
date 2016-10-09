"""
The **pcl_search** library provides methods for searching for nearest neighbors
using different data structures.

http://docs.pointclouds.org/trunk/group__search.html

## Exports

$(EXPORTS)
"""
module PCLSearch

export Search, getName, setSortedResults, getSortedResults, Octree, KdTree

using DocStringExtensions
using LibPCL
using PCLCommon
using PCLKDTree
using PCLOctree
using Cxx

const libpcl_search = LibPCL.find_library_e("libpcl_search")
try
    Libdl.dlopen(libpcl_search, Libdl.RTLD_GLOBAL)
catch e
    warn("You might need to set DYLD_LIBRARY_PATH to load dependencies proeprty.")
    rethrow(e)
end

cxx"""
#include <pcl/search/octree.h>
#include <pcl/search/kdtree.h>
"""

import PCLCommon: setInputCloud, getInputCloud, getIndices

abstract Search

getName(s::Search) = bytestring(icxx"$(s.handle)->getName();")
setSortedResults(s::Search, sorted::Bool) =
    icxx"$(s.handle)->setSortedResults($sorted);"
getSortedResults(s::Search) = icxx"$(s.handle)->setSortedResults();"
setInputCloud(s::Search, cloud::PointCloud) =
    icxx"$(s.handle)->setInputCloud($(cloud.handle));"
getInputCloud(s::Search) =
    PointCloud(icxx"$(s.handle)->getInputCloud();")
getIndices(s::Search) = icxx"$(s.handle)->getIndices();"

@defpcltype Octree{T} <: Search "pcl::search::Octree"
@defptrconstructor Octree{T}(v::AbstractFloat) "pcl::search::Octree"
@defconstructor OctreeVal{T}(v::AbstractFloat) "pcl::search::Octree"

@defpcltype KdTree{T} <: Search "pcl::search::KdTree"
@defptrconstructor KdTree{T}(sorted::Bool=true) "pcl::search::KdTree"
@defconstructor KdTreeVal{T}(sorted::Bool=true) "pcl::search::KdTree"


end # module
