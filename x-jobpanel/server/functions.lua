GetJobDataWithLabel = function(label)
    local serverJobs = exports["x-jobs"]:GetJobs()

    for jobName, jobData in pairs(serverJobs) do
        if jobData.Label == label then
            return jobName
        end
    end

    return false
end