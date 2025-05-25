$(document).ready(() => {
    const Application = new Vue({
        el: "#overlay",
        vuetify: new Vuetify(),
        data: {
            Show: false,

            selected: 0,

            Character: {
                firstname: "Amadeus",
                lastname: "Leijonhjärta",
                dateofbirth: "1993-06-16",
                lastdigits: "1080",
                characterId: "1993-06-16-1080"
            },

            Account: {
                Accounts: [
                    {
                        AccountLabel: "Personligtkonto",
                        AccountNumber: "1234-5678-9101-1234",
                        AccountBalance: 502423,

                        AccountCreator: "1993-06-16-1080",

                        AccountMembers: [
                            {
                                Name: "Amadeus Leijonhjärta",
                                CharacterId: "1993-06-16-1080"
                            },
                            {
                                Name: "Frans Florén",
                                CharacterId: "1993-02-16-2452"
                            },
                        ]
                    },
                ],
                MaxAccounts: 3,
            },

            ActiveNavigation: 0,

            Dialog: {
                Show: false,

                Header: "är du över 18?",
                Text: "Du måste vara över 18 för att vara här...",

                Input: {
                    Show: false,

                    Value: "",
                },

                CancelButtonColor: "red",
                CancelButton: "Avbryt",

                ConfirmButtonColor: "green",
                ConfirmButton: "Godkänn",

                ButtonCallback: function (confirmed) {
                    this.Callback(confirmed);

                    this.Show = false;
                    this.Input.Value = "";
                },

                Callback: function (confirmed) {
                    console.log(confirmed);
                },
            },
            MembersDialog: {
                Show: false,

                Header: "är du över 18?",
          
                CancelButtonColor: "red",
                CancelButton: "Avbryt",

                ButtonCallback: function (confirmed) {
                    this.Callback(confirmed);

                    this.Show = false;
                },

                Callback: function (confirmed) {
                    console.log(confirmed);
                },
            },

            SearchTransaction: "",
            TransactionsHeaders: [
                {
                    text: "Transaktionstyp",
                    align: "start",
                    value: "Description",
                },
                {
                    text: "Summa",
                    value: "Amount",
                },
                {
                    text: "Datum",
                    value: "Date",
                },
                // {
                //     text: "Alternativ",
                //     value: "Actions",
                //     sortable: false
                // }
            ],
            Transactions: [
                {
                    Description: "Betalade en faktura!",
                    Type: "removed",
                    Amount: 50000,
                    Account: "1234-5678-9101-1234",
                },
            ],
        },
        created: function () {
            this.$vuetify.theme.dark = true;
        },
        watch: {
            selected: function(newValue, oldValue) {
                if (newValue === undefined || newValue === null) {
                    this.selected = oldValue;
                }
            }
        },
        methods: {
            openDeleteDialog: function (transaction) {
                this.Dialog.Show = true;

                this.Dialog.Header = "Vill du radera transaktionen?";
                this.Dialog.Text =
                    "Genom att godkänna detta kommer du att radera transaktionen '" +
                    transaction.Description +
                    "' något som ej går att få tillbaka.";

                this.Dialog.ConfirmButton = "Radera";
                this.Dialog.ConfirmButtonColor = "red";

                let focus = this;

                this.Dialog.Callback = function (confirmed) {
                    if (confirmed) {
                        const transactions = focus.Transactions.filter(
                            (trans) => {
                                return (
                                    trans.Date !== transaction.Date &&
                                    trans.Description !== transaction.Date
                                );
                            }
                        );

                        focus.Transactions = transactions;

                        emitEvent(
                            "x-banking:serverAction",
                            {
                                Action: `DELETE_TRANSACTION`,
                                Transaction: transaction,
                            },
                            true
                        );
                    }
                };
            },
            openAccountMembers: function(selected) {
                this.MembersDialog.Show = true;
                this.MembersDialog.Header = `${this.Account.Accounts[selected].AccountLabel} | Medlemmar`
            },
            openActionAccount: function (accountIndex, withdraw) {
                const account = this.Account.Accounts[accountIndex];

                if (!account) return false;

                this.Dialog.Show = true;

                this.Dialog.Input.Show = true;
                this.Dialog.Input.Label = `Hur mycket vill du ${
                    withdraw ? "ta ut" : "sätta in"
                }?`;
                this.Dialog.Input.Hint = `En siffra över 0.`;

                this.Dialog.Header = `${withdraw ? "TA UT" : "SäTT IN"}`;

                this.Dialog.ConfirmButton = `${withdraw ? "TA UT" : "SäTT IN"}`;
                this.Dialog.ConfirmButtonColor = `${
                    withdraw ? "error" : "success"
                }`;

                let focus = this;

                this.Dialog.Callback = function (confirmed) {
                    if (confirmed) {
                        if (focus.Dialog.Input.Value > 1000000) {
                            focus.Dialog.Input.Value = 1000000;
                        }

                        emitEvent(
                            "x-banking:serverAction",
                            {
                                Action: `${
                                    withdraw ? "WITHDRAW" : "DEPOSIT"
                                }_MONEY`,
                                Account: account,
                                Amount: focus.Dialog.Input.Value,
                            },
                            true
                        );
                    }
                };
            },
            openInviteToAccount: function (accountIndex) {
                const account = this.Account.Accounts[accountIndex];

                if (!account) return false;

                this.Dialog.Show = true;

                this.Dialog.Input.Show = true;
                this.Dialog.Input.Label = `Vem vill du bjuda in, skriv dennes personnummer.`;
                this.Dialog.Input.Hint = `XXXX-XX-XX-XXXX`;

                this.Dialog.Header = `Bjud in`;

                this.Dialog.ConfirmButton = `SKICKA`;
                this.Dialog.ConfirmButtonColor = `success`;

                let focus = this;

                this.Dialog.Callback = function (confirmed) {
                    if (confirmed) {
                        if (focus.Dialog.Input.Value > 1000000) {
                            focus.Dialog.Input.Value = 1000000;
                        }

                        emitEvent(
                            "x-banking:serverAction",
                            {
                                Action: `INVITE_TO_ACCOUNT`,
                                Account: account,
                                CharacterId: focus.Dialog.Input.Value,
                            },
                            true
                        );
                    }
                };
            },
            openConfirmDeletion: function (accountIndex) {
                const account = this.Account.Accounts[accountIndex];

                if (!account) return false;

                this.Dialog.Show = true;

                this.Dialog.Input.Show = false;

                this.Dialog.Header = `Radera ${account.AccountLabel}`;
                this.Dialog.Text = `Vill du verkligen radera "${account.AccountLabel}"? Alla pengar kommer att försvinna.`;

                this.Dialog.ConfirmButton = `RADERA`;
                this.Dialog.ConfirmButtonColor = `error`;

                this.Dialog.Callback = function (confirmed) {
                    if (confirmed) {
                        emitEvent(
                            "x-banking:serverAction",
                            {
                                Action: `DELETE_ACCOUNT`,
                                AccountName: account.AccountName,
                            },
                            true
                        );
                    }
                };
            },
            openConfirmLeave: function (accountIndex) {
                const account = this.Account.Accounts[accountIndex];

                if (!account) return false;

                this.Dialog.Show = true;

                this.Dialog.Input.Show = false;

                this.Dialog.Header = `Lämna ${account.AccountLabel}`;
                this.Dialog.Text = `Vill du verkligen lämna "${account.AccountLabel}"? Du måste bli tillagd igen.`;

                this.Dialog.ConfirmButton = `LäMNA`;
                this.Dialog.ConfirmButtonColor = `error`;

                this.Dialog.Callback = function (confirmed) {
                    if (confirmed) {
                        emitEvent(
                            "x-banking:serverAction",
                            {
                                Action: `LEAVE_ACCOUNT`,
                                Account: account,
                            },
                            true
                        );
                    }
                };
            },
            openCreateAccount: function () {
                this.Dialog.Show = true;

                this.Dialog.Input.Show = true;
                this.Dialog.Input.Label = `Vad ska bankkontot heta?`;
                this.Dialog.Input.Hint = `Mitt sparkonto`;

                this.Dialog.Header = `Skapa bankkonto`;

                this.Dialog.ConfirmButton = `SKAPA`;
                this.Dialog.ConfirmButtonColor = `success`;

                let focus = this;

                this.Dialog.Callback = function (confirmed) {
                    if (confirmed) {
                        emitEvent(
                            "x-banking:serverAction",
                            {
                                Action: `CREATE_ACCOUNT`,
                                AccountName: focus.Dialog.Input.Value,
                            },
                            true
                        );
                    }
                };
            },
            openAccountTransactions: function(accountIndex) {
                this.SearchTransaction = this.Account.Accounts[accountIndex];
                this.ActiveNavigation = 1;
            },
            renameAccount: function(accountIndex) {
                const account = this.Account.Accounts[accountIndex];

                this.Dialog.Show = true;

                this.Dialog.Input.Show = true;
                this.Dialog.Input.Label = `Vad ska bankkontot heta?`;
                this.Dialog.Input.Hint = `Mitt sparkonto`;

                this.Dialog.Header = `Redigera bankkonto`;

                this.Dialog.ConfirmButton = `äNDRA`;
                this.Dialog.ConfirmButtonColor = `success`;

                let focus = this;

                this.Dialog.Callback = function (confirmed) {
                    if (confirmed) {
                        emitEvent(
                            "x-banking:serverAction",
                            {
                                Action: `RENAME_ACCOUNT`,
                                AccountName: account.AccountName,
                                NewAccountLabel: focus.Dialog.Input.Value,
                            },
                            true
                        );
                    }
                };
            },
            kickMember: function(member) {
                this.Dialog.Show = true;

                this.Dialog.Header = `Sparka ${member.Name}`;
                this.Dialog.Text = "Du kommer att sparka personen.";

                this.Dialog.Input.Show = false;

                this.Dialog.ConfirmButton = `SPARKA`;
                this.Dialog.ConfirmButtonColor = `success`;

                let focus = this;

                this.Dialog.Callback = function (confirmed) {
                    if (confirmed) {
                        emitEvent(
                            "x-banking:serverAction",
                            {
                                Action: `KICK_MEMBER`,
                                AccountName: focus.Account.Accounts[focus.selected].AccountName,

                                Member: member
                            },
                            true
                        );
                    }
                };
            },

            isOwnerOfAccount(accountIndex) {
                const account = this.Account.Accounts[accountIndex];

                if (!account) return false;

                const characterId = `${this.Character.dateofbirth}-${this.Character.lastdigits}`;

                if (account.AccountName === `PERSONAL_${characterId}`)
                    return false;

                return account.AccountCreator === characterId;
            },
            isAccountPersonal(accountIndex) {
                const account = this.Account.Accounts[accountIndex];

                if (!account) return false;

                const characterId = `${this.Character.dateofbirth}-${this.Character.lastdigits}`;

                if (account.AccountName === `PERSONAL_${characterId}`)
                    return true;

                return false;
            },

            getTransactions() {
                const chosenAccount = this.SearchTransaction;

                if (!chosenAccount) {
                    return [];
                }

                for (
                    let currentTransactionIndex = 0;
                    currentTransactionIndex < this.Transactions.length;
                    currentTransactionIndex++
                ) {
                    const transaction =
                        this.Transactions[currentTransactionIndex];

                    if (!transaction.Account) {
                        this.Transactions[currentTransactionIndex].Account =
                            this.Account.Accounts[0].AccountNumber;
                    }
                }

                let transactions = this.Transactions.filter((e) => {
                    return e.Account === chosenAccount.AccountNumber;
                });

                transactions.reverse();

                return transactions.length > 0 ? transactions : [];
            },

            closeNUI: function () {
                this.Show = false;

                emitEvent("x-banking:closeNUI");
            },
        },
        computed: {},
    });

    emitEvent = (event, data, server) => {
        const options = {
            method: "POST",
            body: JSON.stringify({ event, data }),
        };

        fetch(
            `http://nuipipe/nui_${server ? "server" : "client"}_response`,
            options
        );
    };

    handleKeyUp = (e) => {
        if (e.keyCode === 27) {
            if (Application.Dialog.Show) {
                Application.Dialog.Show = false;
            } else {
                Application.closeNUI();
            }
        }
    };

    addEventListener("message", function (passed) {
        let action = passed.data.Action;

        let data = passed.data.Data;

        switch (action) {
            case "OPEN_BANKING_NUI":
                Application.Show = true;

                Application.Character = data.Character;

                if (data.Transactions) {
                    Application.Transactions = data.Transactions;

                    Application.ActiveNavigation = 0;
                }

                Application.Account.Accounts = data.Accounts;

                break;
            default:
                // console.log("Could not read message with action: " + data["action"])
                break;
        }
    });

    addEventListener("keyup", this.handleKeyUp);
});
