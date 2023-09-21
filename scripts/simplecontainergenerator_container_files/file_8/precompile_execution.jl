import CSV # pkg_names_to_import
import DataFrames # pkg_names_to_import

import Pkg
for (uuid, info) in Pkg.dependencies()
if info.name in ["CSV", "DataFrames"] # pkg_names_to_test
ENV["PREDICTMD_TEST_PLOTS"] = "true"
ENV["PREDICTMD_TEST_GROUP"] = "all"

include(joinpath(info.source, "test", "runtests.jl"))
end
end

