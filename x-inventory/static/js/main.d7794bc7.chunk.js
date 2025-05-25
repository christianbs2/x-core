(this.webpackJsonpqalle_inventory = this.webpackJsonpqalle_inventory || []).push([
    [0],
    {
        22: function (t, e, n) {
            t.exports = n(33);
        },
        27: function (t, e, n) {},
        28: function (t, e, n) {},
        33: function (t, e, n) {
            "use strict";
            n.r(e);
            var a = n(0),
                i = n.n(a),
                o = n(8),
                r = n.n(o),
                s = (n(27), n(28), n(16)),
                c = n(4),
                l = n(5),
                u = n(11),
                m = n(7),
                f = n(6),
                h = n(1),
                d = n.n(h),
                v =
                    (n(14),
                    n(15),
                    (function (t) {
                        Object(m.a)(n, t);
                        var e = Object(f.a)(n);
                        function n(t) {
                            var a;
                            return (
                                Object(c.a)(this, n),
                                ((a = e.call(this, t)).onItemLeave = function () {
                                    a.props.onItemLeave();
                                }),
                                (a.onItemHover = function () {}),
                                (a.onItemClick = function () {
                                    a.props.onItemHover(
                                        (function (t) {
                                            var e = t.getBoundingClientRect();
                                            return { left: e.left + window.scrollX, top: e.top + window.scrollY };
                                        })(a.element.current),
                                        a.props.item
                                    );
                                }),
                                (a.handleHiddenItemClick = function () {
                                    a.setState({ loading: !0 }),
                                        setTimeout(function () {
                                            a.setState({ loading: !1 }), a.props.onLoadingComplete(a.props.item);
                                        }, 1500);
                                }),
                                (a.element = i.a.createRef()),
                                (a.state = { label: "", loading: !1 }),
                                a
                            );
                        }
                        return (
                            Object(l.a)(n, [
                                { key: "componentDidMount", value: function () {} },
                                {
                                    key: "componentDidUpdate",
                                    value: function () {
                                        var t = this;
                                        d()(".item").draggable({
                                            revert: !0,
                                            revertDuration: 0,
                                            scroll: !1,
                                            helper: "clone",
                                            appendTo: "body",
                                            start: function (e, n) {
                                                if ("hidden" === n.helper[0].classList[0]) return !1;
                                                d()(this).hide(),
                                                    t.setState({ label: d()(this).siblings()[0].textContent }),
                                                    (d()(this).siblings()[0].textContent = ""),
                                                    t.props.startedDragging(t.props.item),
                                                    t.setState({ dragging: t.props.item });
                                            },
                                            stop: function (e, n) {
                                                d()(this).show(), d()(this).siblings().html(t.state.label), t.props.stoppedDragging(), t.setState({ dragging: t.props.item });
                                            },
                                        });
                                    },
                                },
                                {
                                    key: "render",
                                    value: function () {
                                        var t = this.props.item,
                                            e = t.Logo,
                                            n = t.Name,
                                            o = t.Count,
                                            r = t.Weight,
                                            s = t.Durability;
                                        return i.a.createElement(
                                            a.Fragment,
                                            null,
                                            this.props.item.Hidden
                                                ? i.a.createElement("div", { className: "hidden", onClick: this.handleHiddenItemClick }, this.state.loading ? i.a.createElement("div", { className: "lds-dual-ring" }) : "")
                                                : i.a.createElement(
                                                      "div",
                                                      { ref: this.element, className: "item", "data-props": JSON.stringify(this.props), onMouseLeave: this.onItemLeave, onMouseEnter: this.onItemHover, onClick: this.onItemClick },
                                                      i.a.createElement("div", { className: "item-count" }, o, "money" === n ? "kr" : "st"),
                                                      i.a.createElement("div", { className: "item-image default ".concat(void 0 !== e ? e : n) }),
                                                      i.a.createElement("div", { className: "item-weight" }, Math.round(o * r * 100) / 100, "kg"),
                                                      void 0 !== s ? i.a.createElement("div", { className: "item-bar", style: { width: "".concat(s, "%"), left: "calc((100% - ".concat(s, "%) / 2)") } }, s, "%") : ""
                                                  )
                                        );
                                    },
                                },
                            ]),
                            n
                        );
                    })(a.Component)),
                g = (function (t) {
                    Object(m.a)(n, t);
                    var e = Object(f.a)(n);
                    function n(t) {
                        var a;
                        return (
                            Object(c.a)(this, n),
                            ((a = e.call(this, t)).getLabelLength = function () {
                                if (
                                    ((String.prototype.trunc =
                                        String.prototype.trunc ||
                                        function (t) {
                                            return this.length > t ? this.substr(0, t - 1) + "..." : this;
                                        }),
                                    a.transformData().Label)
                                )
                                    return a.transformData().Label.trunc(15);
                            }),
                            (a.determineItem = function () {
                                return void 0 !== a.props.item
                                    ? i.a.createElement(v, {
                                          startedDragging: function () {
                                              return a.props.startedDragging();
                                          },
                                          stoppedDragging: function () {
                                              return a.props.stoppedDragging();
                                          },
                                          onLoadingComplete: function (t) {
                                              return a.props.onLoadingComplete(t);
                                          },
                                          onItemLeave: a.props.onItemLeave,
                                          onItemHover: function (t, e) {
                                              return a.props.onItemHover(t, e);
                                          },
                                          action: a.props.action,
                                          item: a.props.item,
                                      })
                                    : null;
                            }),
                            (a.transformData = function () {
                                return void 0 !== a.props.item ? a.props.item : "";
                            }),
                            (a.state = { isActive: !1 }),
                            a
                        );
                    }
                    return (
                        Object(l.a)(n, [
                            {
                                key: "componentDidMount",
                                value: function () {
                                    var t = this;
                                    d()(".inventory-slot").droppable({
                                        accept: ".item",
                                        drop: function (e, n) {
                                            if (1 === d()(this).children().length) {
                                                var a = JSON.parse(this.getAttribute("data-props"));
                                                t.props.onDrop(a, d()(n.draggable).data("props"));
                                            } else 2 === d()(this).children().length && t.props.onSwitch(d()(n.draggable).data("props"), d()(this.children[0]).data("props"));
                                        },
                                        over: function (t, e) {
                                            this.scrollIntoView({ behavior: "smooth", block: "nearest" });
                                        },
                                    }),
                                        d()(".inventory-slot").hover(
                                            function () {
                                                var e = JSON.parse(d()(this)[0].getAttribute("data-props"));
                                                t.props.slot === e.slot && t.props.action === e.action && t.setState({ isActive: !0 });
                                            },
                                            function () {
                                                t.setState({ isActive: !1 });
                                            }
                                        );
                                },
                            },
                            {
                                key: "render",
                                value: function () {
                                    var t = this.determineItem();
									const myString = this.props.action;
                                    
                                    return i.a.createElement(
                                        "div",
                                        { 
											className: `inventory-slot${(this.props.active(this.props.item) || this.state.isActive) ? "-active" : ""} ${myString.startsWith("POCKETS_") ? "leftslot" : ""}`, 
											"data-props": JSON.stringify(this.props)
										},
                                        t,
                                        i.a.createElement("div", { className: "inventory-slot-label" }, this.transformData().Hidden ? "" : this.getLabelLength())
                                    );
                                },
                            },
                        ]),
                        n
                    );
                })(a.Component),
                p = (function (t) {
                    Object(m.a)(n, t);
                    var e = Object(f.a)(n);
                    function n() {
                        var t;
                        Object(c.a)(this, n);
                        for (var a = arguments.length, o = new Array(a), r = 0; r < a; r++) o[r] = arguments[r];
                        return (
                            ((t = e.call.apply(e, [this].concat(o))).state = { check: !1, active: !1 }),
                            (t.renderTabs = function () {
                                var e = [];
                                return (
                                    t.props.container.forEach(function (n, a) {
                                        var o = "";
                                        t.props.activeContainers === n.action && (o = "inventory-box-tab-selected"),
                                            e.push(
                                                i.a.createElement(
                                                    "div",
                                                    {
                                                        onClick: function () {
                                                            return t.props.onChangeTab(n.action);
                                                        },
                                                        key: a,
                                                        className: "inventory-box-tab ".concat(o),
                                                    },
                                                    t.getLabelLength(n.actionLabel) +
                                                        ("(" + n.items.length + "/" + n.slots + ")")
                                                )
                                            );
                                    }),
                                    e
                                );
                            }),
							
                            (t.showCash = function () {
                                var e = [];
								var o = "";
								const myString = t.props.container[0].action;
                                return (
								i.a.createElement(
										"div",
										{
											key: a,
											className: "inventory-cash-text",
										},
										 ("Kontanter: " + t.props.data.kontanter + " Kr")
									)
                                );
                            }),
							(t.renderBar = function () {
                                var e = [];
								var o = "";
								const myString = t.props.container[0].action;
								setTimeout(function() {
									moveeee(t.getTotalWeight() === 0 ? "0" : t.getTotalWeight()/t.props.data.maxWeight * 100);
								  }, 100);
                                return (
								i.a.createElement(
										"div",
										{
											key: a,
											className: "inventory-progress",
										},
										 (t.getTotalWeight() === 0 ? "" : t.getTotalWeight() + "/" + t.props.data.maxWeight + "kg")
									)
                                );
                            }),
                            (t.getLabelLength = function (t) {
                                if (
                                    ((String.prototype.trunc =
                                        String.prototype.trunc ||
                                        function (t) {
                                            return this.length > t ? this.substr(0, t - 1) + "..." : this;
                                        }),
                                    t)
                                )
                                    return t.trunc(16);
                            }),
                            (t.getTotalWeight = function () {
                                for (var e = 0, n = t.props.data.items, a = 0; a < n.length; a++) {
                                    var i = n[a];
                                    e += i.Weight * i.Count;
                                }
                                return Math.round(100 * e) / 100;
                            }),
                            (t.onSwitch = function (e, n) {
                                t.state.check || (t.props.onSwitch(e, n), t.setState({ check: !1 })),
                                    t.setState({ check: !0 }, function () {
                                        setTimeout(function () {
                                            t.setState({ check: !1 });
                                        }, 1);
                                    });
                            }),
                            (t.onDrop = function (e, n) {
                                t.state.check || (t.props.onDrop(e, n), t.setState({ check: !1 })),
                                    t.setState({ check: !0 }, function () {
                                        setTimeout(function () {
                                            t.setState({ check: !1 });
                                        }, 1);
                                    });
                            }),
                            (t.renderData = function (e) {
                                for (var n = 0; n < t.props.data.items.length; n++) if (e === t.props.data.items[n].Slot) return t.props.data.items[n];
                            }),
                            t
                        );
                    }
                    return (
                        Object(l.a)(n, [
                            {
                                key: "render",
                                value: function () {
                                    var t = this.props.data.slots,
                                        e = this.renderSlot(t);
									const myString = this.props.container[0].action;
                                    
                                    return i.a.createElement(
                                        a.Fragment,
                                        null,
                                        i.a.createElement(
                                            "div",
                                            { className: "inventory-box" },
                                            i.a.createElement("div", { className: "inventory-box-tabs" }, this.renderTabs()),
                                            i.a.createElement("div", { className: "inventory-box-inner" }, e.slotsRendered),
                                            myString.startsWith("POCKETS_") ? i.a.createElement("div", { className: "cash-display" }, this.showCash()) : "",
                                            this.getTotalWeight() === 0 ?  "" : i.a.createElement("div", { className: "inventory-vikt-bar meter" }, this.renderBar())
                                        )
                                    );
                                },
                            },
                            {
                                key: "renderSlot",
                                value: function (t) {
                                    var e = this,
                                        n = [];
                                    if (this.props.activeContainers === this.props.data.action)
                                        for (var a = 0; a < t; a++)
                                            n.push(
                                                i.a.createElement(g, {
                                                    startedDragging: function (t) {
                                                        e.setState({ dragging: t });
                                                    },
                                                    stoppedDragging: function () {
                                                        e.setState({ dragging: !1 });
                                                    },
                                                    active: function (t) {
                                                        return e.isActive(t);
                                                    },
                                                    onLoadingComplete: function (t) {
                                                        return e.props.onLoadingComplete(t, e.props.activeContainers, e.props.dir);
                                                    },
                                                    onItemLeave: this.props.onItemLeave,
                                                    onItemHover: function (t, n) {
                                                        return e.onHover(t, n);
                                                    },
                                                    key: a,
                                                    slot: a,
                                                    onSwitch: function (t, n) {
                                                        return e.onSwitch(t, n);
                                                    },
                                                    onDrop: function (t, n) {
                                                        return e.onDrop(t, n);
                                                    },
                                                    action: this.props.data.action,
                                                    item: this.renderData(a),
                                                })
                                            );
                                    return { slotsRendered: n, specialSlots: [] };
                                },
                            },
                            {
                                key: "isActive",
                                value: function (t) {
                                    return void 0 !== t && this.state.active === t.UUID;
                                },
                            },
                            {
                                key: "onHover",
                                value: function (t, e) {
                                    this.setState({ active: e.UUID }), this.props.onItemHover(t, e);
                                },
                            },
                        ]),
                        n
                    );
                })(a.Component),
                b = n(47),
                C = (function (t) {
                    Object(m.a)(n, t);
                    var e = Object(f.a)(n);
                    function n(t) {
                        var a;
                        return Object(c.a)(this, n), ((a = e.call(this, t)).state = { notification: { header: "", content: "", duration: null, visible: null } }), a;
                    }
                    return (
                        Object(l.a)(n, [
                            {
                                key: "componentDidMount",
                                value: function () {
                                    var t = this,
                                        e = this.state.notification,
                                        n = this.props.data,
                                        a = n.header,
                                        i = n.content,
                                        o = n.duration;
                                    (e.header = a),
                                        (e.content = i),
                                        (e.duration = o),
                                        (e.visible = !0),
                                        this.setState({ notification: e }, function () {
                                            setTimeout(function () {
                                                (e.visible = !1), t.setState({ notification: e });
                                            }, o);
                                        });
                                },
                            },
                            {
                                key: "render",
                                value: function () {
                                    var t = this.state.notification,
                                        e = t.header,
                                        n = t.content,
                                        a = t.visible;
                                    return (
                                        null === a && (a = !1),
                                        i.a.createElement(
                                            b.a,
                                            { timeout: 500, classNames: "inventory-notification", appear: !0, leave: !a, in: a, unmountOnExit: !0 },
                                            i.a.createElement("div", { className: "notification" }, i.a.createElement("div", { className: "notification-header" }, e), i.a.createElement("div", { className: "notification-content" }, n))
                                        )
                                    );
                                },
                            },
                        ]),
                        n
                    );
                })(a.Component),
                S = n(46),
                y = (function (t) {
                    Object(m.a)(n, t);
                    var e = Object(f.a)(n);
                    function n(t) {
                        var o;
                        return (
                            Object(c.a)(this, n),
                            ((o = e.call(this, t)).emitClientEvent = function (t, e) {
                                var n = { method: "POST", body: JSON.stringify({ event: t, data: e }) };
                                fetch("http://nuipipe/nui_client_response", n);
                            }),
                            (o.boxDroppable = function () {
                                var t = Object(u.a)(o);
                                d()(".inventory-box-tab").droppable({
                                    accept: ".item",
                                    over: function (t, e) {},
                                    drop: function (e, n) {
                                        var a,
                                            i,
                                            o = e.target.innerHTML,
                                            r = t.state.containers.leftContainer,
                                            s = t.state.containers.rightContainer;
                                        if (
                                            (r.forEach(function (t) {
                                                o.includes(t.actionLabel) && ((a = t.action), (i = "left"));
                                            }),
                                            s.forEach(function (t) {
                                                o.includes(t.actionLabel) && ((a = t.action), (i = "right"));
                                            }),
                                            null !== a && null !== i)
                                        ) {
                                            var c = t.generateFreeSlot(a);
                                            if (!1 !== c) {
                                                var l = { action: a, slot: c };
                                                t.handleDrop(l, d()(n.draggable).data("props"));
                                            } else t.sendNotification({ header: "Inventory", content: "Föremålet får inte plats här (Rutor).", duration: 4e3 });
                                        }
                                    },
                                });
                            }),
                            (o.handleKeyUp = function (t) {
                                27 === t.keyCode || 9 === t.keyCode ? (o.emitClientEvent("x-inventory:closeInventory"), d()(".overlay").fadeOut()) : 16 === t.keyCode && o.setState({ ctrlClick: !1 });
                            }),
                            (o.handleKeyDown = function (t) {
                                16 === t.keyCode && o.setState({ ctrlClick: !0 });
                            }),
                            (o.generateFreeSlot = function (t) {
                                var e,
                                    n = Object(u.a)(o),
                                    a = n.state.containers.leftContainer,
                                    i = n.state.containers.rightContainer,
                                    r = [];
                                a.forEach(function (n) {
                                    if (n.action === t) {
                                        e = n.slots;
                                        for (var a = 0; a < n.items.length; a++) {
                                            var i = n.items[a];
                                            i && void 0 !== i.Slot && (r[i.Slot.toString()] = !0);
                                        }
                                    }
                                }),
                                    i.forEach(function (n) {
                                        if (n.action === t) {
                                            e = n.slots;
                                            for (var a = 0; a < n.items.length; a++) {
                                                var i = n.items[a];
                                                i && void 0 !== i.Slot && (r[i.Slot.toString()] = !0);
                                            }
                                        }
                                    });
                                for (var s = 0; s < e; s++) if (!r[s.toString()]) return s;
                                return !1;
                            }),
                            (o.sendNotification = function (t) {
                                var e = o.state.notifications;
                                e.length > 10 && e.shift(), e.push(t), o.setState({ notifications: e });
                            }),
                            (o.renderContainers = function () {
                                var t = [],
                                    e = o.state.containers.leftContainer,
                                    n = o.state.containers.rightContainer,
                                    a = 0;
                                return (
                                    e.forEach(function (e) {
                                        o.state.activeContainers.left === e.action &&
                                            (t.push(
                                                i.a.createElement(p, {
                                                    onLoadingComplete: function (t, e, n) {
                                                        return o.handleLoadingComplete(t, e, n);
                                                    },
                                                    onItemLeave: o.handleItemLeave,
                                                    onItemHover: function (t, e) {
                                                        return o.handleItemHover(t, e);
                                                    },
                                                    onChangeTab: function (t) {
                                                        o.handleTabChange(t, "left");
                                                    },
                                                    dir: "left",
                                                    activeContainers: o.state.activeContainers.left,
                                                    container: o.state.containers.leftContainer,
                                                    onSwitch: function (t, e) {
                                                        return o.handleSwitch(t, e);
                                                    },
                                                    onDrop: function (t, e) {
                                                        return o.handleDrop(t, e);
                                                    },
                                                    data: e,
                                                    key: 0,
                                                })
                                            ),
                                            a++);
                                    }),
                                    n.forEach(function (e) {
                                        o.state.activeContainers.right === e.action &&
                                            (t.push(
                                                i.a.createElement(p, {
                                                    onLoadingComplete: function (t, e, n) {
                                                        return o.handleLoadingComplete(t, e, n);
                                                    },
                                                    onItemLeave: o.handleItemLeave,
                                                    onItemHover: function (t, e) {
                                                        return o.handleItemHover(t, e);
                                                    },
                                                    onChangeTab: function (t) {
                                                        o.handleTabChange(t, "right");
                                                    },
                                                    dir: "right",
                                                    activeContainers: o.state.activeContainers.right,
                                                    container: o.state.containers.rightContainer,
                                                    onSwitch: function (t, e) {
                                                        return o.handleSwitch(t, e);
                                                    },
                                                    onDrop: function (t, e) {
                                                        return o.handleDrop(t, e);
                                                    },
                                                    data: e,
                                                    key: 1,
                                                })
                                            ),
                                            a++);
                                    }),
                                    2 !== a && o.setState({ activeContainers: { left: e[0].action, right: n[0].action } }),
                                    t
                                );
                            }),
                            (o.handleLoadingComplete = function (t, e, n) {
                                var a = o.state.containers.leftContainer,
                                    i = o.state.containers.rightContainer,
                                    r = o.state.containers;
                                if ("left" === n) {
                                    for (var s = 0; s < a.length; s++)
                                        if (a[s].action === e) for (var c = 0; c < a[s].items.length; c++) a[s].items[c].Slot === t.Slot && ((a[s].items[c].Hidden = !1), (r.leftContainer = a), o.setState({ containers: r }));
                                } else if ("right" === n)
                                    for (var l = 0; l < i.length; l++)
                                        if (i[l].action === e) for (var u = 0; u < i[l].items.length; u++) i[l].items[u].Slot === t.Slot && ((i[l].items[u].Hidden = !1), (r.rightContainer = i), o.setState({ containers: r }));
                            }),
                            (o.handleItemLeave = function () {}),
                            (o.quickSwitch = function (t) {
                                var e = o.getContainerFromItem(t),
                                    n = o.state.activeContainers.left === e.action ? "RIGHT" : "LEFT",
                                    a = o.getOpenedContainer(n),
                                    i = o.generateFreeSlot(a.action);
                                !1 !== i && o.handleDrop({ action: a.action, slot: i }, { action: e.action, item: t });
                            }),
                            (o.getContainerFromItem = function (t) {
                                for (var e, n = o.state.containers.leftContainer, a = o.state.containers.rightContainer, i = 0; i < n.length; i++)
                                    for (var r = n[i], s = 0; s < r.items.length; s++)
                                        if (r.items[s].UUID === t.UUID) {
                                            e = r;
                                            break;
                                        }
                                for (var c = 0; c < a.length; c++)
                                    for (var l = a[c], u = 0; u < l.items.length; u++)
                                        if (l.items[u].UUID === t.UUID) {
                                            e = l;
                                            break;
                                        }
                                return e;
                            }),
                            (o.getOpenedContainer = function (t) {
                                var e,
                                    n = o.state.containers.leftContainer,
                                    a = o.state.containers.rightContainer;
                                if ("LEFT" === t)
                                    for (var i = 0; i < n.length; i++) {
                                        var r = n[i];
                                        if (r.action === o.state.activeContainers.left) {
                                            e = r;
                                            break;
                                        }
                                    }
                                else if ("RIGHT" === t)
                                    for (var s = 0; s < a.length; s++) {
                                        var c = a[s];
                                        if (c.action === o.state.activeContainers.right) {
                                            e = c;
                                            break;
                                        }
                                    }
                                return e;
                            }),
                            (o.handleItemHover = function (t, e) {
                                if (o.state.ctrlClick) return o.quickSwitch(e);
                                var n = o.state.infoBox;
                                (n.object = void 0),
                                    (n.info = []),
                                    (n.offset.left = 0),
                                    (n.offset.top = 0),
                                    (n.info.item = e),
                                    "object" == typeof e.Description ? (n.object = e.Description) : (n.info.text = e.Description),
                                    (n.info.label = e.Label),
                                    (n.visible = !0),
                                    o.setState({ infoBox: n });
                            }),
                            (o.handleTabChange = function (t, e) {
                                var n = o.state.activeContainers;
                                (n[e] = t), o.setState({ activeContainers: n });
                            }),
                            (o.getAmount = function () {
                                return i.a.createElement(
                                    a.Fragment,
                                    null,
                                    i.a.createElement(
                                        b.a,
                                        { timeout: 500, classNames: "inventory-info-box-animation", appear: !1, leave: !o.state.infoBox.visible, in: o.state.infoBox.visible },
                                        i.a.createElement(
                                          "div",
                                          { style: { left: o.state.infoBox.offset.left, top: o.state.infoBox.offset.top }, className: "inventory-info-box" },
                                          i.a.createElement("div", { className: "inventory-info-box-item-label" }, "".concat(o.state.infoBox.info.label)),
                                          i.a.createElement("div", { className: "inventory-info-box-item-image default ".concat(void 0 !== o.state.infoBox.info.item.Logo ? o.state.infoBox.info.item.Logo : o.state.infoBox.info.item.Name) }), // Use the correct property for the item image
                                          void 0 !== o.state.infoBox.info.item.Image ? 
                                            i.a.createElement("img", {
                                                style: { 
                                                display: "block", 
                                                margin: "0 auto", 
                                                borderRadius: "5%", 
                                                width: "50%" 
                                                }, 
                                                src: "".concat(o.state.infoBox.info.item.Image) 
                                            }) 
                                            : "",
                                          void 0 === o.state.infoBox.object
                                            ? i.a.createElement("div", { className: "inventory-info-box-item-text" }, void 0 !== o.state.infoBox.info.text ? o.state.infoBox.info.text : "Detta föremål har ingen beskrivning.")
                                            : "",
                                          void 0 !== o.state.infoBox.object
                                            ? o.state.infoBox.object.map(function (t, e) {
                                              return i.a.createElement(
                                                "div",
                                                { className: "inventory-info-box-item-text" },
                                                i.a.createElement("span", { style: { fontWeight: "bold", color: "white", opacity: "80%" } }, t.Title),
                                                " ",
                                                t.Text
                                              );
                                            })
                                            : "",
                                          o.state.infoBox.visible && o.state.infoBox.info.item.UseButton
                                            ? i.a.createElement(
                                              "div",
                                              {
                                                onClick: function () {
                                                  o.useItem();
                                                },
                                                style: { marginRight: "auto", marginLeft: "auto", display: "flex", justifyContent: "center" },
                                                variant: "contained",
                                                color: "default",
                                                className: "inventory-info-box-item-button"
                                              },
                                              o.state.infoBox.info.item.UseButton
                                            )
                                            : ""
                                        )
                                      ),
                                    i.a.createElement(
                                        "div",
                                        null,
                                        i.a.createElement("div", { className: "inventory-box-overlay" }, o.renderContainers(), i.a.createElement("logo", { className: "inventory-box-logo" })),
                                        i.a.createElement(
                                            "div",
                                            { className: "inventory-box-buttons" },
                                            i.a.createElement("input", { className: "button-input", placeholder: "ANTAL", value: o.state.inputValue, onChange: o.handleChange, type: "number" })
                                        )
                                    ),
                                    i.a.createElement(
                                        "div",
                                        { className: "inventory-notification-container" },
                                        o.state.notifications.map(function (t, e) {
                                            return i.a.createElement(C, { key: e, data: t });
                                        })
                                    )
                                );
                            }),
                            (o.handleNuiEvent = function (t) {
                                var e = t.data,
                                    n = e.inventory,
                                    a = e.action,
                                    i = e.specificInventoryData,
                                    r = e.bank,
                                    s = e.cash;
                                switch (t.data.Action) {
                                    case "SEND_NOTIFICATION":
                                        o.sendNotification(t.data.data);
                                        break;
                                    case "UPDATE_INVENTORY":
                                        o.setState({ containers: n });
                                        break;
                                    case "UPDATE_SPECIFIC_INVENTORY":
                                        for (var c = 0; c < o.state.containers.leftContainer.length; c++)
                                            if (o.state.containers.leftContainer[c].action === a) {
                                                var l = o.state.containers;
                                                return (l.leftContainer[c] = i), void o.setState({ containers: l });
                                            }
                                        for (var u = 0; u < o.state.containers.rightContainer.length; u++)
                                            if (o.state.containers.rightContainer[u].action === a) {
                                                var m = o.state.containers;
                                                return (m.rightContainer[u] = i), void o.setState({ containers: m });
                                            }
                                        break;
                                    case "UPDATE_MONEY":
                                        var f = o.state.money;
                                        (f.cash = s), (f.bank = r), o.setState({ money: f });
                                        break;
                                    case "OPEN_INVENTORY":
                                        d()(".overlay").fadeIn();
                                        break;
                                    default:
                                        console.log("There isn't such an action as ".concat(t, ", please make one or make sure you have spelt it right"));
                                }
                            }),
                            (o.handleChange = function (t) {
                                o.setState({ inputValue: t.target.value });
                            }),
                            (o.handleSwitch = function (t, e) {
                                if (!o.state.busy && e.item.UUID !== t.item.UUID) {
                                    for (var n = !0, a = 0, i = 0, r = Object.entries({ KEYCHAIN: ["key"], ACCESSORIES: ["bag", "mask", "hat", "helmet", "earaccessories", "glasses"] }); i < r.length; i++) {
                                        var c = Object(s.a)(r[i], 2),
                                            l = c[0],
                                            u = c[1];
                                        t.action.includes(l) ? (a++, u.includes(e.item.Name) && (n = !1)) : e.action.includes(l) && (a++, u.includes(t.item.Name) && (n = !1));
                                    }
                                    if (n && a > 0) return o.sendNotification({ header: "Varning", content: "Du får ej lägga in det här.", duration: 4e3 });
                                    var m = ["POCKETS", "KEYCHAIN", "ACCESSORIES"];
                                   
                                    if (("bag" === t.item.Name || "bag" === e.item.Name) && t.action !== e.action) {
                                        for (var f = 0, h = 0; h < m.length; h++) for (var d = m[h], v = o.getContainer(d).items, g = 0; g < v.length; g++) "bag" === v[g].Name && f++;
                                        if (f > 0) return o.sendNotification({ header: "Inventory", content: "Föremålet kan inte läggas in här, du har redan ett av detta.", duration: 4e3 });
                                    }
                                    o.setState({ busy: !0 }),
                                        setTimeout(function () {
                                            o.setState({ busy: !1 });
                                        }, 150);
                                    var p = !1,
                                        b = JSON.parse(JSON.stringify(t)),
                                        C = JSON.parse(JSON.stringify(e)),
                                        S = !!parseInt(o.state.inputValue) && parseInt(o.state.inputValue);
                                    if (
                                        (b.item.Stackable && b.item.Name === C.item.Name && (p = !0),
                                        p && (S && (S > b.item.Count && (S = b.item.Count), (b.item.OldCount = parseInt(b.item.Count)), (b.item.Count = parseInt(S))), e.action !== t.action))
                                    ) {
                                        var y = o.getContainer(e.action),
                                            I = parseInt(b.item.Count),
                                            E = -1 === y.maxWeight ? 9999999 : y.maxWeight;
                                        if (C.item.Weight * I + o.getTotalWeight(e.action) > E) return o.sendNotification({ header: "Inventory", content: "Föremålet får inte plats här (Vikt) (Stackable).", duration: 4e3 });
                                    }
                                    o.deleteItem(b), o.deleteItem(C);
                                    for (var N = 0; N < o.state.containers.leftContainer.length; N++) {
                                        var k = o.state.containers;
                                        k.leftContainer[N].action === b.action && (p || ((C.item.Slot = t.item.Slot), k.leftContainer[N].items.push(C.item))),
                                            k.leftContainer[N].action === C.action && (p ? k.leftContainer[N].items.push(C.item) : ((b.item.Slot = e.item.Slot), k.leftContainer[N].items.push(b.item))),
                                            o.setState({ containers: k });
                                    }
                                    for (var x = 0; x < o.state.containers.rightContainer.length; x++) {
                                        var D = o.state.containers;
                                        D.rightContainer[x].action === b.action && (p || ((C.item.Slot = t.item.Slot), D.rightContainer[x].items.push(C.item))),
                                            D.rightContainer[x].action === C.action && (p ? D.rightContainer[x].items.push(C.item) : ((b.item.Slot = e.item.Slot), D.rightContainer[x].items.push(b.item))),
                                            o.setState({ containers: D });
                                    }
                                    var L = { target: { action: C.action, slot: b.item.Slot }, element: { action: b.action, item: b.item } },
                                        O = { target: { action: b.action, slot: C.item.Slot }, element: { action: C.action, item: C.item } };
                                    p
                                        ? o.emitClientEvent("x-inventory:combineItems", { target: O, initiator: L })
                                        : (o.emitClientEvent("x-inventory:dropItem", { target: L.target, element: L.element }), o.emitClientEvent("x-inventory:dropItem", { target: O.target, element: O.element }));
                                }
                            }),
                            (o.handleDrop = function (t, e) {
                                if (!o.state.busy) {
                                    var n = ["POCKETS", "KEYCHAIN"];
                                    o.setState({ busy: !0 });
                                    var a = !1,
                                        i = !!parseInt(o.state.inputValue) && parseInt(o.state.inputValue);
                                    if (
                                        (i && i < e.item.Count && ((a = e.item.Count), (e.item.Count = parseInt(i))),
                                        setTimeout(function () {
                                            o.setState({ busy: !1 });
                                        }, 150),
                                        t.action !== e.action)
                                    ) {
                                        for (
                                            var r = o.getContainer(t.action), c = e.item, l = !0, u = 0, m = 0, f = Object.entries({ KEYCHAIN: ["key"], ACCESSORIES: ["mask", "hat", "helmet", "earaccessories", "glasses"] });
                                            m < f.length;
                                            m++
                                        ) {
                                            var h = Object(s.a)(f[m], 2),
                                                d = h[0],
                                                v = h[1];
                                            e.action.includes(d) ? (u++, (l = !1)) : t.action.includes(d) && (u++, v.includes(c.Name) && (l = !1));
                                        }
                                        if (l && u > 0) return o.sendNotification({ header: "Varning", content: "Du får ej lägga in det här.", duration: 4e3 });
                                        if (t.action.includes("BAG") && "bag" === c.Name) return o.sendNotification({ header: "Inventory", content: "Du kan inte lägga en väska i en väska.", duration: 4e3 });
                                        if ("bag" === c.Name) {
                                            for (var g = 0, p = !1, b = 0; b < n.length; b++) {
                                                var C = n[b];
                                                t.action.includes(C) && (p = !0);
                                            }
                                            if (p) for (var S = 0; S < n.length; S++) for (var y = n[S], I = o.getContainer(y).items, E = 0; E < I.length; E++) I[E].Name === c.Name && g++;
                                            if (g > 0) return o.sendNotification({ header: "Inventory", content: "Föremålet kan inte läggas in här, du har redan ett av detta.", duration: 4e3 });
                                        }
                                        if (t.action.includes("KEYCHAIN") && "key" !== c.Name) return o.sendNotification({ header: "Nyckelknippa", content: "Bara nycklar får läggas här.", duration: 4e3 });
                                        var N = -1 === r.maxWeight ? 9999999 : r.maxWeight;
                                        if (c.Weight * c.Count + o.getTotalWeight(t.action) > N) return o.sendNotification({ header: "Inventory", content: "Föremålet får inte plats här (Vikt).", duration: 4e3 });
                                    }
                                    o.emitClientEvent("x-inventory:dropItem", { target: t, element: e, createNew: a });
                                    for (var k = JSON.parse(JSON.stringify(e)), x = 0; x < o.state.containers.leftContainer.length; x++)
                                        if (o.state.containers.leftContainer[x].action === t.action) {
                                            k.item.Slot = t.slot;
                                            var D = o.state.containers;
                                            return D.leftContainer[x].items.push(k.item), o.setState({ containers: D }), void o.deleteItem(e);
                                        }
                                    for (var L = 0; L < o.state.containers.rightContainer.length; L++)
                                        if (o.state.containers.rightContainer[L].action === t.action) {
                                            k.item.Slot = t.slot;
                                            var O = o.state.containers;
                                            return O.rightContainer[L].items.push(k.item), o.setState({ containers: O }), void o.deleteItem(e);
                                        }
                                }
                            }),
                            (o.deleteItem = function (t) {
                                for (var e = o.state.containers, n = 0; n < o.state.containers.leftContainer.length; n++)
                                    if (o.state.containers.leftContainer[n].action === t.action) {
                                        var a = o.state.containers.leftContainer[n].items.filter(function (e) {
                                            return e.Slot !== t.item.Slot;
                                        });
                                        (e.leftContainer[n].items = a), o.setState({ containers: e });
                                    }
                                for (var i = 0; i < o.state.containers.rightContainer.length; i++)
                                    if (o.state.containers.rightContainer[i].action === t.action) {
                                        var r = o.state.containers.rightContainer[i].items.filter(function (e) {
                                            return e.Slot !== t.item.Slot;
                                        });
                                        (e.rightContainer[i].items = r), o.setState({ containers: e });
                                    }
                            }),
                            (o.useItem = function () {
                                var t = o.state.infoBox.info.item;
                                if (void 0 !== t) {
                                    var e = Object(u.a)(o);
                                    e.emitClientEvent("x-inventory:closeInventory"), e.emitClientEvent("x-inventory:useItem", t), d()(".overlay").fadeOut();
                                    var n = o.state.infoBox;
                                    (n.visible = !1), o.setState({ infoBox: n });
                                }
                            }),
                            (o.getContainer = function (t) {
                                for (var e = o.state.containers, n = 0; n < e.leftContainer.length; n++) {
                                    var a = e.leftContainer[n];
                                    if (a.action.includes(t)) return a;
                                }
                                for (var i = 0; i < e.rightContainer.length; i++) {
                                    var r = e.rightContainer[i];
                                    if (r.action.includes(t)) return r;
                                }
                            }),
                            (o.getTotalWeight = function (t) {
                                for (var e, n = o.state.containers, a = 0; a < n.leftContainer.length; a++) {
                                    var i = n.leftContainer[a];
                                    i.action === t && (e = i);
                                }
                                for (var r = 0; r < n.rightContainer.length; r++) {
                                    var s = n.rightContainer[r];
                                    s.action === t && (e = s);
                                }
                                for (var c = 0, l = e.items, u = 0; u < l.length; u++) {
                                    var m = l[u];
                                    c += m.Weight * m.Count;
                                }
                                return Math.round(100 * c) / 100;
                            }),
                            (o.state = {
                                amount: 1664345109498,
                                inputValue: "",
                                money: { cash: 0, bank: 0 },
                                busy: !1,
                                activeContainers: { left: "inventory", right: "ground" },
                                activeElement: {},
                                infoBox: { offset: { left: 0, top: 0 }, visible: !1, info: { label: "", text: "", item: [] } },
                                ctrlClick: !1,
                                notifications: [],
                                containers: {
                                    leftContainer: [
                                        {
                                            action: "POCKETS_1993-06-16",
                                            actionLabel: "Ryggsäck",
                                            slots: 25,
                                            maxWeight: 2,
                                            items: [
                                                { Name: "mobile_phone", Label: "iPhone 8", Count: 1, Slot: 8, Weight: 0.2, UUID: "39b9571b-23232323-429d-b9b0-23232332323", Durability: 73, UseButton: "STäNG AV" },
                                                {
                                                    Name: "id_card",
                                                    Label: "Identifikation",
                                                    Count: 1,
                                                    Slot: 0,
                                                    Weight: 0.2,
                                                    UUID: "39b9571b-2323233323-429d-b9b0-23232332323",
                                                    UseButton: "INSPEKTERA",
                                                    Image: "http://i.imgur.com/Yb9qrhX.jpg",
                                                },
                                                { Name: "phone", Label: "iPhone X", Count: 1, Slot: 6, Weight: 0.2, UUID: "39b239571b-99bc-429d-b9b0-23232332323", UseButton: "AVAKTIVERA TELEFONEN" },
                                            ],
                                        },
                                        {
                                            action: "KEYCHAIN_1993-06-16",
                                            actionLabel: "Nyckelknippa",
                                            slots: 25,
                                            maxWeight: 8,
                                            items: [
                                                { Name: "key", Label: "69 Väg 32", Count: 1, Slot: 0, Weight: 0.2, UUID: "39b9571b-99bc-429d-b9b0-sxdsdxs" },
                                                { Name: "key", Label: "75 Väg 69", Count: 23, Slot: 1, Weight: 0.2, UUID: "39b9571b-99bc-429d-b9b0-jrtjrtjrt" },
                                            ],
                                        },
                                        {
                                            action: "ACCESSORIES_1993-06-16",
                                            actionLabel: "Accessoarer",
                                            slots: 25,
                                            maxWeight: 8,
                                            items: [
                                                { Name: "hat", Label: "Hatt", Count: 1, Slot: 0, Weight: 0.2, UUID: "39b9571b-232323-429d-b9b0-sxdsdxs" },
                                                { Name: "glasses", Label: "Glasögon", Count: 1, Slot: 1, Weight: 0.2, UUID: "39b9571b-99bc-429d-b9b0-jrtjrtjrt" },
                                            ],
                                        },
                                    ],
                                    rightContainer: [{ action: "ground", actionLabel: "Marken", slots: 25, maxWeight: -1, items: [] }],
                                },
                            }),
                            o
                        );
                    }
                    return (
                        Object(l.a)(n, [
                            {
                                key: "componentDidMount",
                                value: function () {
                                    this.boxDroppable(), window.addEventListener("keydown", this.handleKeyDown), window.addEventListener("keyup", this.handleKeyUp), window.addEventListener("message", this.handleNuiEvent);
                                },
                            },
                            {
                                key: "componentDidUpdate",
                                value: function () {
                                    this.boxDroppable();
                                },
                            },
                            {
                                key: "render",
                                value: function () {
                                    return this.getAmount();
                                },
                            },
                        ]),
                        n
                    );
                })(a.Component);
            Boolean("localhost" === window.location.hostname || "[::1]" === window.location.hostname || window.location.hostname.match(/^127(?:\.(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}$/)),
                r.a.render(
                    i.a.createElement(function () {
                        return i.a.createElement("div", { className: "overlay" }, i.a.createElement("div", { className: "overlay-inner" }, i.a.createElement(y, null)));
                    }, null),
                    document.getElementById("root")
                ),
                "serviceWorker" in navigator &&
                    navigator.serviceWorker.ready.then(function (t) {
                        t.unregister();
                    });
        },
    },
    [[22, 1, 2]],
]);

function moveeee(progressPercent) {
  var elem = document.querySelector(".inventory-progress");
  if (!elem) {
    console.error("Element not found!");
    return;
  }
  
  var width = 0;
  var id = setInterval(frame, 10);
  function frame() {
    if (width >= progressPercent) {
      clearInterval(id);
	  if (progressPercent <= 0) {
		  elem.style.width = '0px';
	  }
    } else {
		  width++; 
		  elem.style.width = width + '%';

    }
  }
}

