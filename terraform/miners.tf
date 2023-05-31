# this file has secrets
# do not ever commit to repo
# after updating, update the sensitive variable in the TF Cloud workspace

variable "zenottaMiners" {
    type = list
    default = [
        # Node 0
        [
            {
                owner = "skibidi-yes"
                api_key = "API_KEY"
                period = "1-year"
            },
            {
                owner = "skibidi-yes"
                api_key = "API_KEY"
                period = "1-year"
            },
            {
                owner = "skibidi-yes"
                api_key = "API_KEY"
                period = "1-year"
            },
            {
                owner = "kokkewiet"
                api_key = "API_KEY"
                period = "1-year"
            },
            {
                owner = "gert-janse"
                api_key = "API_KEY"
                period = "1-year"
            },
            {
                owner = "gert-janse"
                api_key = "API_KEY"
                period = "1-year"
            },
            {
                owner = "gert-janse"
                api_key = "API_KEY"
                period = "1-year"
            },
            {
                owner = "gert-janse"
                api_key = "API_KEY"
                period = "1-year"
            }
        ],
        # Node 1
        [
            {
                owner = "gert-janse"
                api_key = "API_KEY"
                period = "1-year"
            },
            {
                owner = "gert-janse"
                api_key = "API_KEY"
                period = "1-year"
            },
            {
                owner = "gert-janse"
                api_key = "API_KEY"
                period = "1-year"
            },
            {
                owner = "gert-janse"
                api_key = "API_KEY"
                period = "1-year"
            },
            {
                owner = "gert-janse"
                api_key = "API_KEY"
                period = "1-year"
            },
            {
                owner = "gert-janse"
                api_key = "API_KEY"
                period = "1-year"
            },
            {
                owner = "gert-janse"
                api_key = "API_KEY"
                period = "1-year"
            },
            {
                owner = "gert-janse"
                api_key = "API_KEY"
                period = "1-year"
            }
        ],
        # Node 2
        [
            {
                owner = "mnr-van-vuuren"
                api_key = "API_KEY"
                period = "1-year"
            },
            {
                owner = "mnr-van-vuuren"
                api_key = "API_KEY"
                period = "1-year"
            },
            {
                owner = "mnr-van-vuuren"
                api_key = "API_KEY"
                period = "1-year"
            },
            {
                owner = "mnr-van-vuuren"
                api_key = "API_KEY"
                period = "1-year"
            },
            {
                owner = "mnr-van-vuuren"
                api_key = "API_KEY"
                period = "1-year"
            },
            {
                owner = "mnr-van-vuuren"
                api_key = "API_KEY"
                period = "1-year"
            },
            {
                owner = "mnr-van-vuuren"
                api_key = "API_KEY"
                period = "1-year"
            },
            {
                owner = "mnr-van-vuuren"
                api_key = "API_KEY"
                period = "1-year"
            }
        ]
    ]
}