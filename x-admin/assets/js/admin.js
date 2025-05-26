$(document).ready(() => {
    const Application = new Vue({
        el: "#overlay",
        vuetify: new Vuetify(),
        data: {
            Show: false,

            ActiveNavigation: 0,

            Page: "PLAYERS_LIST",
            PageData: {
                Name: "Qalle",

                Status: [
                    {
                        Label: "Steam Hex",
                        Value: "steam:1100008008",
                        Icon: "mdi-account"
                    },
                    {
                        Label: "Första Inlogg",
                        Value: "2020-10-24 23:24:54",
                        Icon: "mdi-clock"
                    },
                    {
                        Label: "IP",
                        Value: "83.253.161.251",
                        Icon: "mdi-connection",
                        Hidden: true,
                    },
                    {
                        Label: "Whitelist",
                        Value: "2020-10-24 22:11:43",
                        Icon: "mdi-receipt",
                        Event: "x-admin:removeWhitelist"
                    }
                ],

                Characters: [
                    {
                        characterId: "1993-06-16-1080",
                        firstname: "Amadeus",
                        lastname: "Leijonhjärta"
                    },
                    {
                        characterId: "2002-06-16-1233",
                        firstname: "Mehmet",
                        lastname: "Mehamed"
                    },
                    {
                        characterId: "1942-06-16-1233",
                        firstname: "Mango",
                        lastname: "Klementin",
                        gender: "F"
                    },
                    {
                        characterId: "1957-06-16-1233",
                        firstname: "Frippe",
                        lastname: "Nmyna"
                    }
                ]
            },
            LastPages: [],

            Player: {
                Name: "Qalle"
            },

            Navigation: {
                Show: true,

                Current: 0
            },

            Button: {
                Loading: false
            },

            SearchPlayer: "",

            PlayerHeaders: [
                {
                    text: "ID",
                    align: "start",
                    value: "Id"
                },
                {
                    text: "Steam Hex",
                    value: "Identifier"
                },
                {
                    text: "Namn",
                    value: "Name"
                },
                {
                    text: "Karaktär",
                    value: "Character"
                },
                {
                    text: "Ping",
                    value: "Ping"
                },
                {
                    text: "Alternativ",
                    value: "Actions",
                    sortable: false
                }
            ],
            Players: [
                {
                    Id: 1,
                    Identifier: "steam:110000100f71108",
                    Name: "Qalle",
                    Character: "Emelie Walker",
                    Ping: 34
                }
            ],

            Companies: [
                {
                    Name: "Polismyndigheten",

                    HasJob: 13,
                    InDuty: 11
                },
                {
                    Name: "Sjukvården",

                    HasJob: 6,
                    InDuty: 5
                },
                {
                    Name: "LS-Customs",

                    HasJob: 4,
                    InDuty: 2
                },
                {
                    Name: "Transportbolaget",

                    HasJob: 4,
                    InDuty: 2
                }
            ],

            Toplist: [
                {
                    Label: "Ekonomi",
                    Players: [
                        {
                            Name: "Qalle",

                            Character: "Amadeus Leijonhjärta",

                            Amount: "1373"
                        }
                    ],
                    Prefix: "",
                    Suffix: " kr"
                },
                {
                    Label: "Speltimmar",
                    Players: [
                        {
                            Name: "Qalle",

                            Character: "Amadeus Leijonhjärta",

                            Amount: "343 timmar och 15 minuter"
                        },
                        {
                            Name: "BakverkRP",

                            Character: "Johnny Baker",

                            Amount: "247 timmar och 12 minuter"
                        },
                        {
                            Name: "Mangos",

                            Character: "Filippa Feminim",

                            Amount: "1223 timmar och 9 minuter"
                        },
                        {
                            Name: "Zeaqy",

                            Character: "Afro Hjärndöd",

                            Amount: "-1 timmar och -25 minuter"
                        },
                        {
                            Name: "Lök",

                            Character: "Carl Grävling",

                            Amount: "5000 timmar och 22 minuter"
                        }
                    ],
                    Prefix: "",
                    Suffix: ""
                },
                {
                    Label: "Tjänstetimmar",
                    Players: [
                        {
                            Name: "Qalle",

                            Character: "Amadeus Leijonhjärta",

                            Amount: "12 timmar och 10 minuter"
                        }
                    ],
                    Prefix: "",
                    Suffix: ""
                }
            ],

            Gang: {
                GangHeaders: [
                    {
                        text: "Namn",
                        align: "start",
                        value: "Name"
                    },
                    {
                        text: "Medlemmar",
                        value: "Members"
                    },
                    {
                        text: "Skapare",
                        value: "Creator"
                    },
                    {
                        text: "Alternativ",
                        value: "Actions",
                        sortable: false
                    }
                ],
                Gangs: [
                    {
                        Name: "The Lost MC",
                        MemberCount: 9,
                        Creator: "Carl Flink",
                        Data: {
                            Members: [
                                {
                                    Name: "Carl Flink",
                                    CharacterId: "2000-00-00-0000",
                                    Joined: "2020-06-16"
                                }
                            ]
                        }
                    }
                ],

                MemberHeaders: [
                    {
                        text: "För- och efternamn",
                        align: "start",
                        value: "Name"
                    },
                    {
                        text: "Personnummer",
                        value: "CharacterId"
                    },
                    {
                        text: "Alternativ",
                        value: "Actions",
                        sortable: false
                    }
                ],
            },

            Stocks: {
                Page: "DELIVERY",
                AvailableItems: {
                    DELIVERY: [
                        //Droger
                        {
                            Label: "Ecstasy",
                            Name: "ecstasy",
                            Price: 33,
                            MaxCount: 250,
                        },
                        {
                            Label: "Gräs 1g",
                            Name: "zipbag1g",
                            Price: 35,
                            MaxCount: 250,
                        },
                        {
                            Label: "Paket med Droger",
                            Name: "drug_package",
                            Price: 1000,
                            MaxCount: 25
                        },
                        {
                            Label: "Tokarev TT-33 grepp",
                            Name: "vintage_grip",
                            Price: 1450,
                            MaxCount: 5
                        },
                        {
                            Label: "Tokarev TT-33 fjäder",
                            Name: "vintage_spring",
                            Price: 1200,
                            MaxCount: 5
                        },
                        {
                            Label: "Tokarev TT-33 pipa",
                            Name: "vintage_pipe",
                            Price: 800,
                            MaxCount: 5
                        },
                        {
                            Label: "Tokarev TT-33 mantel",
                            Name: "vintage_mantle",
                            Price: 1650,
                            MaxCount: 5
                        },
                        {
                            Label: "Tokarev TT-33 vapenskiss",
                            Name: "vintagepistol_print",
                            Price: 5000,
                            MaxCount: 5
                        },
                        {
                            Label: "Termit",
                            Name: "thermite",
                            Price: 5000,
                            MaxCount: 10
                        } 
                    ],
                    LUCY: [
                        {
                            Label: "Lustgas",
                            Name: "nitrous_oxide",
                            Price: 2499,
                            MaxCount: 10
                        },
                        {
                            Label: "Skottsäkerväst",
                            Name: "bulletproof_vest",
                            Price: 15000,
                            MaxCount: 50
                        },
                        {
                            Label: "Pistolammunition",
                            Name: "pistol_ammo",
                            Price: 500,
                            MaxCount: 100
                        },
                        {
                            Label: "Shotgunammunition",
                            Name: "shotgun_ammo",
                            Price: 800,
                            MaxCount: 100
                        },
                        {
                            Label: "Smgammunition",
                            Name: "smg_ammo",
                            Price: 750,
                            MaxCount: 100
                        },
                        {
                            Label:"Ammo låda Rifle",
                            Name: "rifle_ammo_box",
                            Price: 15000,
                            MaxCount: 5
                            
                        }
                    ]
                }
            },

            Dialog: {
                Show: false,

                Header: "är du över 18?",
                Text: "Du måste vara över 18 för att vara här...",

                CancelButtonColor: "red",
                CancelButton: "Avbryt",

                ConfirmButtonColor: "green",
                ConfirmButton: "Godkänn",

                ButtonCallback: function (confirmed) {
                    this.Callback(confirmed);

                    this.Show = false;
                },

                Callback: function (confirmed) {
                    console.log(confirmed)
                }
            }
        },
        created: function () {
            this.$vuetify.theme.dark = true;
        },
        methods: {
            openPlayerPage: function (player) {
                emitEvent("x-admin:getPlayerInformation", player);
            },
            openCharacterPage: function (characterId) {
                const character = this.PageData.Characters.filter((char) => {
                    return char.characterId === characterId;
                })

                if (character[0]) {
                    let newData = this.PageData;

                    newData.Character = character[0];

                    this.changePage("CHARACTER", false, newData);
                }
            },
            openLastPage: function () {
                const lastPages = this.LastPages;
                const lastPage = lastPages.length - 1;

                this.changePage(lastPages[lastPage].Page, true, lastPages[lastPage].Data);

                this.LastPages.splice(lastPage, 1);
            },
            changePage: function (newPage, lastPage, pageData) {
                if (!lastPage)
                    this.LastPages.push({
                        Page: this.Page,
                        Data: this.PageData
                    });

                if (pageData)
                    this.PageData = pageData;

                this.Page = newPage;
            },

            saveCharacter: function () {
                this.Button.Loading = true;

                const characterData = this.PageData.Character;

                emitEvent("x-admin:action", {
                    Action: "SAVE_CHARACTER",
                    Character: characterData,
                }, true)

                setTimeout(() => {
                    this.Button.Loading = false;
                }, 1500);
            },
            saveSkills: function () {
                this.Button.Loading = true;

                const characterData = this.PageData.Character;
                const newSkills = this.PageData.Character.skills;

                emitEvent("x-admin:action", {
                    Action: "EDIT_SKILLS",
                    CharacterId: characterData.characterId,
                    Skills: newSkills
                }, true)

                setTimeout(() => {
                    this.Button.Loading = false;
                }, 1500);
            },

            editGarage: function (vehicle) {
                emitEvent("x-admin:action", {
                    Action: "EDIT_GARAGE",
                    Vehicle: vehicle
                });
            },
            editInside: function (vehicle) {
                emitEvent("x-admin:action", {
                    Action: "UPDATE_IMPOUND",
                    Vehicle: vehicle
                }, true);
            },

            getWaypoint: function (property) {
                emitEvent("x-housing:eventHandler", property)
            },

            deleteDamage: function (damage) {
                let application = this;

                this.Dialog.Show = true;

                this.Dialog.Header = `Vill du ta bort skadan?`;
                this.Dialog.Text = `Genom att godkänna detta kommer du att ta bort skadan - ${damage.Label}.`;

                this.Dialog.ConfirmButton = "Godkänn";
                this.Dialog.ConfirmButtonColor = "green";

                this.Dialog.Callback = function (confirmed) {
                    if (confirmed) {
                        const character = application.PageData.Character.characterId;

                        const newDamages = application.PageData.Character.damages.filter((cDamage) => {
                            return cDamage.Label !== damage.Label;
                        });

                        application.PageData.Character.damages = newDamages;

                        emitEvent("x-admin:action", {
                            Action: "REMOVE_DAMAGE",
                            CharacterId: character,
                            Damage: damage
                        }, true);
                    }
                }
            },
            deleteAllDamages: function () {
                let application = this;

                this.Dialog.Show = true;

                this.Dialog.Header = `Vill du ta bort alla skador?`;
                this.Dialog.Text = `Genom att godkänna detta kommer du att ta bort alla skador på karaktären.`;

                this.Dialog.ConfirmButton = "Godkänn";
                this.Dialog.ConfirmButtonColor = "green";

                this.Dialog.Callback = function (confirmed) {
                    if (confirmed) {
                        const character = application.PageData.Character.characterId;

                        const newDamages = [];

                        application.PageData.Character.damages = newDamages;

                        emitEvent("x-admin:action", {
                            Action: "REMOVE_DAMAGES",
                            CharacterId: character
                        }, true);
                    }
                }
            },
            healCharacter: function () {
                const character = this.PageData.Character.characterId;

                this.PageData.Character.health = 200;

                emitEvent("x-admin:action", {
                    Action: "HEAL_CHARACTER",
                    CharacterId: character
                }, true);
            },
            reviveOrKillCharacter: function () {
                const character = this.PageData.Character.characterId;

                if (this.PageData.Character.dead) {
                    emitEvent("x-admin:action", {
                        Action: "REVIVE_CHARACTER",
                        CharacterId: character
                    }, true);
                } else {
                    emitEvent("x-admin:action", {
                        Action: "KILL_CHARACTER",
                        CharacterId: character
                    }, true);
                }

                this.PageData.Character.dead = !this.PageData.Character.dead;
            },
            deleteCooldown: function (cooldown) {
                let application = this;

                this.Dialog.Show = true;

                this.Dialog.Header = `Vill du ta bort cooldownen?`;
                this.Dialog.Text = `Genom att godkänna detta kommer du att ta bort cooldown - ${cooldown.Label}.`;

                this.Dialog.ConfirmButton = "Godkänn";
                this.Dialog.ConfirmButtonColor = "green";

                this.Dialog.Callback = function (confirmed) {
                    if (confirmed) {
                        const character = application.PageData.Character.characterId;

                        const newCooldowns = application.PageData.Character.cooldowns.filter((cCooldown) => {
                            return cCooldown.Label !== cooldown.Label;
                        });

                        application.PageData.Character.cooldowns = newCooldowns;

                        emitEvent("x-admin:action", {
                            Action: "REMOVE_COOLDOWN",
                            CharacterId: character,
                            Cooldown: cooldown.Id
                        }, true);
                    }
                }
            },

            clickOnStatus: function (status, index) {
                let player = this.PageData;

                if (status.Label === "Whitelist") {
                    this.Dialog.Show = true;

                    this.Dialog.Header = `Vill du ta bort whitelist på ${player.Name}?`;
                    this.Dialog.Text = `Genom att godkänna detta kommer du att ta bort whitelist samt sparka ${player.Name}, vilket kommer leda till att hen förlorar sin plats och kan inte joina igen.`;

                    this.Dialog.ConfirmButton = "Sparka";
                    this.Dialog.ConfirmButtonColor = "red";

                    this.Dialog.Callback = function (confirmed) {
                        if (confirmed) {
                            emitEvent("x-admin:action", {
                                Action: "REMOVE_WHITELIST",
                                Player: player
                            }, true);
                        }
                    }
                } else if (status.Label === "IP") {
                    this.PageData.Status[index].Hidden = !this.PageData.Status[index].Hidden;
                } else if (status.Label === "Tillstånd") {
                    this.Dialog.Show = true;

                    this.Dialog.Header = `Välj vilken rank ${player.Name} ska ha?`;
                    this.Dialog.Multi = [
                        "NORMAL",
                        "FULL_ADMIN",
                        "SUPPORT",
                        "WHITELIST"
                    ];
                    this.Dialog.MultiValue = "";

                    this.Dialog.ConfirmButton = `Uppdatera`;
                    this.Dialog.ConfirmButtonColor = "success";

                    let thisInFunc = this;

                    this.Dialog.Callback = function (confirmed) {
                        if (confirmed) {
                            emitEvent("x-admin:action", {
                                Action: "UPDATE_PERMISSION",
                                Player: player,
                                Permission: thisInFunc.Dialog.MultiValue
                            }, true);

                            player.Status[1].Value = `${thisInFunc.Dialog.MultiValue}`;
                        }
                    }
                }
            },

            kickPlayer: function (player) {
                this.Dialog.Show = true;

                this.Dialog.Header = `Vill du sparka ${player.Name}?`;
                this.Dialog.Text = `Genom att godkänna detta kommer du att sparka ${player.Name}, vilket kommer leda till att hen förlorar sin plats.`;

                this.Dialog.ConfirmButton = "Sparka";
                this.Dialog.ConfirmButtonColor = "red";

                this.Dialog.Callback = function (confirmed) {
                    if (confirmed) {
                        emitEvent("x-admin:action", {
                            Action: "KICK_PLAYER",
                            Player: player.Id,
                            Why: "Du blev kickad av en admin."
                        }, true);
                    }
                }
            },

            convertTime: function (minutes) {
                return `${Math.floor(minutes / 60)} timmar och ${(minutes % 60)} minuter`
            },
            getRules(item) {
                if (item.OrderedCount > item.Count) {
                    if (item.Count <= 0) {
                        return [
                            `Finns inget kvar.`
                        ]
                    }

                    return [
                        `Finns bara ${item.Count} i lager.`
                    ]
                }

                return true;
            },
            getItemLabel(item) {
                return `${item.Label} - ${item.Price * item.OrderedCount} kr`
            },
            getJobIcon(jobName) {
                const icons = {
                    ["Polismyndigheten"]: "shield-star",
                    ["Sjukvården"]: "hospital-building",
                    ["LS-Customs"]: "wrench"
                }

                if (icons[jobName]) {
                    return icons[jobName];
                }

                return "briefcase"
            },

            changeStocks(page) {
                this.Stocks.Page = page;
            },
            saveStonks() {
                if (this.Stocks.Page === "LUCY") {
                    emitEvent("x-tuner:fillStocks", {
                        Stocks: this.Stocks.AvailableItems.LUCY
                    }, true);
                } else {
                    emitEvent("x-gangsystem:fillStocks", {
                        Stocks: this.Stocks.AvailableItems.DELIVERY
                    }, true);
                }
            },

            closeNUI: function () {
                this.Show = false;

                emitEvent("x-admin:closeNUI");
            }
        },
        computed: {
            healthColor: function () {
                const health = this.PageData.Character.health;

                const color = health > 0 ? "red" : "green";

                return color;
            },
        }
    })

    emitEvent = (event, data, server) => {
        const options = {
            method: "POST",
            body: JSON.stringify({ event, data })
        };

        //console.log(`Sending event to client: ${ event } with data: ${ JSON.stringify(data) }`)

        fetch(`http://nuipipe/nui_${server ? "server" : "client"}_response`, options);
    }

    handleKeyUp = (e) => {
        if (e.keyCode === 27) {
            if (Application.Dialog.Show) {
                return Application.Dialog.Show = false;
            } else if (Application.LastPages.length > 0) {
                Application.openLastPage();
            } else {
                Application.closeNUI();
            }
        }
    }

    addEventListener("message", function (passed) {
        let action = passed.data.Action;

        let data = passed.data.Data;

        switch (action) {
            case "OPEN_ADMIN_NUI":
                Application.Show = true;

                Application.ActiveNavigation = 0;
                Application.Page = "PLAYERS_LIST";
                Application.LastPages = [];

                Application.Character = data.Character;
                Application.Player = data.Player;

                Application.Toplist = data.TopList;
                Application.Companies = data.Companies;

                Application.Players = data.Players;
                Application.Gang.Gangs = data.Gangs;

                break;
            case "OPEN_PLAYER_PAGE":
                Application.changePage("PLAYER", false, data);

                break;
            case "OPEN_CHARACTER_PAGE":
                Application.changePage("CHARACTER", false, data);

                break;
            case "CLOSE_ADMIN_NUI":
                Application.closeNUI();

                break;
            default:
                console.log("Could not read message with action: " + data["action"]);
                break;
        }
    })

    addEventListener("keyup", this.handleKeyUp);
});