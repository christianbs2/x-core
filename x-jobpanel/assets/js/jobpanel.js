$(document).ready(() => {
  const Application = new Vue({
    el: "#overlay",
    vuetify: new Vuetify(),
    data: {
      Show: false,

      Character: {
        firstname: "Kenneth",
        lastname: "Johansson",
      },

      ActiveNavigation: 0,

      Vehicles: {
        Search: "",

        Vehicles: [
          {
            VehicleLabel: "XC70",
            Vehicle: "Jonny Mos",
            Price: 13000,
          },
          {
            VehicleLabel: "XC70",
            Vehicle: "Jonny Mos",
            Price: 13000,
          },
          {
            VehicleLabel: "XC70",
            Vehicle: "Jonny Mos",
            Price: 13000,
          },
          {
            VehicleLabel: "XC70",
            Vehicle: "Jonny Mos",
            Price: 13000,
          },
        ],

        Headers: [
          {
            text: "Fordonsnamn",
            align: "start",
            value: "VehicleLabel",
          },
          {
            text: "Pris",
            value: "Price",
          },
          {
            text: "Hantera",
            value: "Actions",
          },
        ],
      },

      Employees: {
        Search: "",

        Characters: [
          {
            Name: "Jonny Mos",
            CharacterId: "1993-06-16-1666",
            Grade: "Aspirant",
            Revenue: 17000,
            MinutesInDuty: 250,
            Permissions: {
              ACCESS_ONE: true,
              ACCESS_TWO: false,
            },
          },
          // {
          //     Name: "Jonny Walker",
          //     CharacterId: "1994-12-13-4432",
          //     Grade: "Löjtnant"
          // },
          // {
          //     Name: "Peter Baker",
          //     CharacterId: "1991-01-02-1333",
          //     Grade: "Rikspolischef"
          // },
          // {
          //     Name: "Melina Kanjietski",
          //     CharacterId: "2001-06-16-1233",
          //     Grade: "Löjtnant"
          // },
        ],

        Headers: [
          {
            text: "För- och efternamn",
            align: "start",
            value: "Name",
          },
          {
            text: "Personnummer",
            value: "CharacterId",
          },
          { text: "Rang (Tryck för att ändra)", value: "Grade" },
          { text: "Hantera", value: "Actions" },
        ],
      },

      Invoices: {
        Search: "",

        Invoices: [
          {
            Id: "58423",
            Name: "Jonny Mos",
            Receiver: "Polismyndigheten",
            TotalAmount: 5373,
            Date: "2020-11-11",
          },
          // {
          //     Name: "Jonny Walker",
          //     CharacterId: "1994-12-13-4432",
          //     Grade: "Löjtnant"
          // },
          // {
          //     Name: "Peter Baker",
          //     CharacterId: "1991-01-02-1333",
          //     Grade: "Rikspolischef"
          // },
          // {
          //     Name: "Melina Kanjietski",
          //     CharacterId: "2001-06-16-1233",
          //     Grade: "Löjtnant"
          // },
        ],

        Headers: [
          {
            text: "Faktura-id",
            align: "start",
            value: "Id",
          },
          {
            text: "Avsändare",
            value: "Name",
          },
          {
            text: "Mottagare",
            value: "Receiver",
          },
          {
            text: "Summa",
            value: "TotalAmount",
          },
          {
            text: "Datum",
            value: "Date",
          },
          {
            text: "Hantera",
            value: "Actions",
          },
        ],
      },

      Job: {
        Name: "POLICE",
        Label: "Polismyndigheten",
        Grade: {
          Label: "Aspirant",
        },
        Grades: ["Aspirant"],
        Permissions: {
          ACCESS_ONE: false,
          ACCESS_TWO: false,
        },

        Boss: true,

        Balance: 50000,
      },

      CharacterDialog: {
        Show: false,

        Character: {
          Permissions: {},
        },
      },

      Dialog: {
        Show: false,

        Header: "är du över 18?",
        Text: "Du måste vara över 18 för att vara här...",

        CancelButtonColor: "red",
        CancelButton: "Avbryt",

        ConfirmButtonColor: "green",
        ConfirmButton: "Godkänn",

        Input: {
          Show: false,

          Value: "",
        },

        ButtonCallback: function (confirmed) {
          this.Callback(confirmed);

          this.Show = false;
        },

        Callback: function (confirmed) {
          console.log(confirmed);
        },
      },
    },
    created: function () {
      this.$vuetify.theme.dark = true;
    },
    mounted: function () {
      // Vue.nextTick(() => {
      //     this.animate_statistic();
      //     this.__typewriter_step($("#jobpanel-homepage-character"), "12st Anställda", 0)
      // });
    },
    methods: {
      depositBalance() {
        this.Dialog.Show = true;

        this.Dialog.Input.Show = true;
        this.Dialog.Input.Label = "Hur mycket vill du sätta in?";
        this.Dialog.Input.Rule = "";
        this.Dialog.Input.Hint = "En siffra över 0.";

        this.Dialog.Header = `Inkassera`;

        this.Dialog.ConfirmButton = "SäTT IN";
        this.Dialog.ConfirmButtonColor = "success";

        let focus = this;

        this.Dialog.Callback = function (confirmed) {
          if (confirmed) {
            emitEvent(
              "x-jobpanel:action",
              {
                Action: "DEPOSIT_BALANCE",
                Amount: focus.Dialog.Input.Value,
                Job: focus.Job.Name,
              },
              true
            );
          }
        };
      },
      withdrawBalance() {
        this.Dialog.Show = true;

        this.Dialog.Input.Show = true;
        this.Dialog.Input.Label = "Hur mycket vill du ta ut?";
        this.Dialog.Input.Rule =
          "!!Det är strikt förbjudet att ta ut ur företaget för egen vinning. Allt loggas!!";
        this.Dialog.Input.Hint = "En siffra över 0.";

        this.Dialog.Header = `Utkassera`;

        this.Dialog.ConfirmButton = "TA UT";
        this.Dialog.ConfirmButtonColor = "success";

        let focus = this;

        this.Dialog.Callback = function (confirmed) {
          if (confirmed) {
            emitEvent(
              "x-jobpanel:action",
              {
                Action: "WITHDRAW_BALANCE",
                Amount: focus.Dialog.Input.Value,
                Job: focus.Job.Name,
              },
              true
            );
          }
        };
      },

      kickCharacter(player) {
        this.Dialog.Show = true;

        this.Dialog.Input.Show = false;

        this.Dialog.Header = `Vill du sparka ${player.Name}?`;
        this.Dialog.Text = `Genom att godkänna detta kommer du att sparka ${player.Name}, vilket kommer leda till att hen förlorar sin anställning.`;

        this.Dialog.ConfirmButton = "Sparka";
        this.Dialog.ConfirmButtonColor = "red";

        let focus = this;

        this.Dialog.Callback = function (confirmed) {
          if (confirmed) {
            emitEvent(
              "x-jobpanel:action",
              {
                Action: "KICK_CHARACTER",
                Character: player,
                Job: focus.Job.Name,
              },
              true
            );

            const index = focus.Employees.Characters.indexOf(player);

            focus.Employees.Characters.splice(index, 1);
          }
        };
      },

      editGrade(character) {
        emitEvent(
          "x-jobpanel:action",
          {
            Action: "EDIT_CHARACTER_GRADE",
            Character: character,
            Job: this.Job.Name,
          },
          true
        );
      },

      hirePerson() {
        this.Dialog.Show = true;

        this.Dialog.Input.Show = true;
        this.Dialog.Input.Label = "Personnummer";
        this.Dialog.Input.Hint = "(XXXX-XX-XX-XXXX)";

        this.Dialog.Header = `Anställ`;

        this.Dialog.ConfirmButton = "ANSTäLL";
        this.Dialog.ConfirmButtonColor = "success";

        let focus = this;

        this.Dialog.Callback = function (confirmed) {
          if (confirmed) {
            emitEvent(
              "x-jobpanel:action",
              {
                Action: "HIRE_CHARACTER",
                CharacterId: focus.Dialog.Input.Value,
                Job: focus.Job.Name,
              },
              true
            );
          }
        };
      },

      orderVehicle(vehicle) {
        this.Dialog.Show = true;

        this.Dialog.Input.Show = false;

        this.Dialog.Header = `Vill du beställa ${vehicle.VehicleLabel}?`;
        this.Dialog.Text = `Genom att godkänna detta kommer du att beställa en ${vehicle.VehicleLabel}, vilket kommer leda till att företaget debiteras.`;

        this.Dialog.ConfirmButton = "Beställ";
        this.Dialog.ConfirmButtonColor = "success";

        let focus = this;

        this.Dialog.Callback = function (confirmed) {
          if (confirmed) {
            emitEvent("x-jobpanel:action", {
              Action: "ORDER_VEHICLE",
              Vehicle: vehicle,
              Job: focus.Job.Name,
            });
          }
        };
      },

      manageCharacter(character) {
        this.CharacterDialog.Show = true;

        this.CharacterDialog.Character = character;
      },
      updatePermission(character, permission) {
        emitEvent(
          "x-jobpanel:action",
          {
            Action: "EDIT_PERMISSION_CHARACTER",
            CharacterId: character.CharacterId,
            Permission: permission,
            Value: character.Permissions[permission],
            Job: this.Job.Name,
          },
          true
        );
      },

      hasAccess(access) {
        if (this.Job.Permissions[access] === true || this.Job.Boss) return true;

        return true;
      },
      hasAccessToEmployees() {
        if (this.hasAccess("ACCESS_ONE")) {
          return true;
        } else if (this.hasAccess("ACCESS_TWO")) {
          return true;
        } else {
          return this.Job.Boss;
        }
      },

      openInvoice(invoice) {
        emitEvent("x-jobpanel:action", {
          Action: "OPEN_INVOICE",
          Invoice: invoice,
          Job: this.Job.Name,
        });
      },
      cancelInvoice(invoice) {
        this.Dialog.Show = true;

        this.Dialog.Input.Show = false;

        this.Dialog.Header = `Vill du annullera faktura?`;
        this.Dialog.Text = `Genom att godkänna detta kommer du att annullera fakturan.`;

        this.Dialog.ConfirmButton = "Annullera";
        this.Dialog.ConfirmButtonColor = "error";

        let focus = this;

        this.Dialog.Callback = function (confirmed) {
          if (confirmed) {
            emitEvent(
              "x-jobpanel:action",
              {
                Action: "CANCEL_INVOICE",
                Invoice: invoice,
                Job: focus.Job.Name,
              },
              true
            );

            const index = focus.Invoices.Invoices.indexOf(invoice);

            focus.Invoices.Invoices.splice(index, 1);
          }
        };
      },

      closeNUI() {
        this.Show = false;

        emitEvent("x-jobpanel:closeNUI");
      },

      animate_statistic: () => {
        let focus = Application;

        const balance = focus.Job.Balance;

        const parts = balance.toString().match(/^(\d+)(.*)/);

        if (parts.length < 2) return;

        const scale = 20;
        const delay = 25;
        const end = 0 + parts[1];
        const suffix = parts[2];

        let next = 0;

        const func = function () {
          const show = Math.ceil(next);

          focus.Job.Balance = "" + show + suffix;

          if (focus.Job.Balance == balance) return;

          next = next + (end - next) / scale;

          window.setTimeout(func, delay);
        };

        func();
      },
      __typewriter_step: (element, text, index) => {
        if (index < text.length) {
          element.text(text.substring(0, index + 1));

          setTimeout(() => {
            Application.__typewriter_step(element, text, index + 1);
          }, 100);
        }
      },
    },
    computed: {},
  });

  emitEvent = (event, data, server) => {
    const options = {
      method: "POST",
      body: JSON.stringify({ event, data }),
    };

    //console.log(`Sending event to client: ${ event } with data: ${ JSON.stringify(data) }`)

    fetch(
      `http://nuipipe/nui_${server ? "server" : "client"}_response`,
      options
    );
  };

  handleKeyUp = (e) => {
    if (e.keyCode === 27) {
      if (Application.Dialog.Show) {
        return (Application.Dialog.Show = false);
      } else {
        Application.closeNUI();
      }
    }
  };

  addEventListener("message", function (passed) {
    let action = passed.data.Action;

    let data = passed.data.Data;

    switch (action) {
      case "OPEN_JOBPANEL_NUI":
        Application.Show = true;

        Application.Character = data.Character;

        Application.Job = data.Job;

        Application.Employees.Characters = data.Employees;
        Application.Vehicles.Vehicles = data.Vehicles;
        Application.Invoices.Invoices = data.Invoices;

        Vue.nextTick(() => {
          Application.animate_statistic();
          Application.__typewriter_step(
            $("#jobpanel-homepage-character"),
            data.Employees.length + "st Anställda",
            0
          );
        });

        break;
      case "EDIT_JOBPANEL_BALANCE":
        Application.Job.Balance = data;

        break;
      case "CLOSE_NUI":
        Application.closeNUI();

        break;
      default:
        console.log("Could not read message with action: " + data["action"]);
        break;
    }
  });

  addEventListener("keyup", this.handleKeyUp);
});
