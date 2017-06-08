import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: appearancePage

    signal configurationChanged

    property alias cfg_autoFillWidth: autoFillWidth.checked
    property alias cfg_horizontalScreenWidthPercent: horizontalScreenWidthPercent.value
    property alias cfg_widthFineTuning: widthFineTuning.value

    property alias cfg_showWindowTitle: showWindowTitle.checked
    property alias cfg_textType: textTypeCombo.currentIndex
    property alias cfg_fitText: fitTextCombo.currentIndex
    property alias cfg_tooltipTextType: tooltipTextTypeCombo.currentIndex
    property alias cfg_showWindowIcon: showWindowIcon.checked
    property alias cfg_windowIconOnTheRight: windowIconOnTheRight.checked
    property alias cfg_useWindowTitleReplace: useWindowTitleReplace.checked
    property alias cfg_replaceTextRegex: replaceTextRegex.text
    property alias cfg_replaceTextReplacement: replaceTextReplacement.text
    property alias cfg_noWindowText: noWindowText.text
    property string cfg_noWindowIcon: plasmoid.configuration.noWindowIcon
    property alias cfg_limitTextWidth: limitTextWidth.checked
    property alias cfg_textWidthLimit: textWidthLimit.value

    property alias cfg_boldFontWeight: boldFontWeight.checked
    property string cfg_fontFamily
    property alias cfg_iconAndTextSpacing: iconAndTextSpacing.value
    property alias cfg_fontSizeScale: fontSizeScale.value

    PlasmaCore.DataSource {
        id: executableDS
        engine: 'executable'

        property string cmdBorderlessRead: 'kreadconfig5 --file kwinrc --group Windows --key BorderlessMaximizedWindows'
        property string cmdBorderlessWrite: 'kwriteconfig5 --file kwinrc --group Windows --key BorderlessMaximizedWindows --type bool {borderless}'
        property string cmdReconfigure: 'qdbus org.kde.KWin /KWin reconfigure'

        connectedSources: []

        onNewData: {
            connectedSources.length = 0
            print('sourceName: ' + sourceName)
            if (sourceName === cmdBorderlessRead) {
                var trimmedStdout = data.stdout.trim()
                print('current value: ' + trimmedStdout)
                toggleBorderlessMaximizedWindows.checked = trimmedStdout === 'true'
            } else if (sourceName.indexOf('kwriteconfig5') === 0) {
                connectedSources.push(cmdReconfigure)
            }
        }
    }

    /* copied from /usr/share/plasma/plasmoids/org.kde.plasma.digitalclock/contents/ui/configAppearance.qml */
    onCfg_fontFamilyChanged: {
        // HACK by the time we populate our model and/or the ComboBox is finished the value is still undefined
        if (cfg_fontFamily) {
            for (var i = 0, j = fontsModel.count; i < j; ++i) {
                if (fontsModel.get(i).value == cfg_fontFamily) {
                    fontFamilyComboBox.currentIndex = i
                    break
                }
            }
        }
    }

    ListModel {
        id: fontsModel
        Component.onCompleted: {
            var arr = [ {text: i18nc("Use default font", "Default"), value: ""} ]
            Qt.fontFamilies().forEach(function (font) {
                arr.push({text: font, value: font})
            })
            append(arr)
            cfg_fontFamilyChanged();
        }
    }

    Component.onCompleted: {
        executableDS.connectedSources.push(executableDS.cmdBorderlessRead)
    }

    GridLayout {
        columns: 2

        Label {
            text: i18n('Plasmoid version: ') + '1.7.3'
            Layout.alignment: Qt.AlignRight
            Layout.columnSpan: 2
        }

        Label {
            text: i18n("Width in horizontal panel:")
            Layout.alignment: Qt.AlignVCenter|Qt.AlignLeft
            Layout.columnSpan: 2
        }

        CheckBox {
            id: autoFillWidth
            text: i18n("Fill width")
            Layout.columnSpan: 2
        }

        GridLayout {
            columns: 2
            Layout.columnSpan: 2
            enabled: !autoFillWidth.checked

            Slider {
                id: horizontalScreenWidthPercent
                stepSize: 0.001
                minimumValue: 0.001
                maximumValue: 1
                Layout.preferredWidth: appearancePage.width
                Layout.columnSpan: 2
            }

            Label {
                text: i18n("Fine tuning:")
                Layout.alignment: Qt.AlignVCenter|Qt.AlignRight
            }
            SpinBox {
                id: widthFineTuning
                decimals: 1
                stepSize: 0.5
                minimumValue: -100
                maximumValue: 100
            }
        }

        Item {
            width: 2
            height: 10
            Layout.columnSpan: 2
        }

        CheckBox {
            id: toggleBorderlessMaximizedWindows
            text: i18n("Hide titlebar for maximized windows (takes effect immediately)")
            Layout.columnSpan: 2
            onCheckedChanged: {
                var preparedCmd = executableDS.cmdBorderlessWrite.replace('{borderless}', String(checked))
                executableDS.connectedSources.push(preparedCmd)
            }
        }

        Item {
            width: 2
            height: 10
            Layout.columnSpan: 2
        }

        GroupBox {
            id: showWindowTitle
            title: i18n("Show window title")
            checkable: true
            flat: true
            Layout.columnSpan: 2

            GridLayout {
                columns: 2

                Item {
                    width: 2
                    height: 10
                    Layout.columnSpan: 2
                }

                Label {
                    text: i18n('Text type:')
                    Layout.alignment: Qt.AlignRight
                }
                ComboBox {
                    id: textTypeCombo
                    model: [i18n('Window title'), i18n('Application name')]
                }

                Label {
                    text: i18n('Fit text:')
                    Layout.alignment: Qt.AlignRight
                }
                ComboBox {
                    id: fitTextCombo
                    model: [i18n('Just elide'), i18n('Fit on hover'), i18n('Always fit')]
                }

                Label {
                    text: i18n('Tooltip text:')
                    Layout.alignment: Qt.AlignRight
                }
                ComboBox {
                    id: tooltipTextTypeCombo
                    model: [i18n('No tooltip'), i18n('Window title'), i18n('Application name')]
                }

                CheckBox {
                    id: useWindowTitleReplace
                    text: '"' + i18n('Window title') + '".replace(/'
                    Layout.alignment: Qt.AlignRight
                }
                GridLayout {
                    columns: 4

                    TextField {
                        id: replaceTextRegex
                        placeholderText: '^(.*)\\s+[—–\\-:]\\s+([^—–\\-:]+)$'
                        Layout.preferredWidth: 300
                        onTextChanged: cfg_replaceTextRegex = text
                        enabled: useWindowTitleReplace.checked
                    }

                    Label {
                        text: '/, "'
                    }

                    TextField {
                        id: replaceTextReplacement
                        placeholderText: '$2 — $1'
                        Layout.preferredWidth: 100
                        onTextChanged: cfg_replaceTextReplacement = text
                        enabled: useWindowTitleReplace.checked
                    }

                    Label {
                        text: '");'
                    }
                }

                Label {
                    text: i18n('No window text:')
                    Layout.alignment: Qt.AlignRight
                }
                TextField {
                    id: noWindowText
                    placeholderText: 'Plasma Desktop'
                    onTextChanged: cfg_noWindowText = text
                    Layout.preferredWidth: 300
                }

                Label {
                    text: i18n("No window icon:")
                    Layout.alignment: Qt.AlignRight
                }
                IconPicker {
                    currentIcon: cfg_noWindowIcon
                    defaultIcon: ''
                    onIconChanged: cfg_noWindowIcon = iconName
                }

                CheckBox {
                    id: limitTextWidth
                    text: i18n('Limit text width')
                    Layout.alignment: Qt.AlignRight
                }
                SpinBox {
                    id: textWidthLimit
                    decimals: 0
                    stepSize: 10
                    minimumValue: 0
                    maximumValue: 10000
                    enabled: limitTextWidth.checked
                    suffix: i18nc('Abbreviation for pixels', 'px')
                }
            }
        }

        Item {
            width: 2
            height: 10
            Layout.columnSpan: 2
        }

        CheckBox {
            id: showWindowIcon
            text: i18n("Show window icon")
            Layout.columnSpan: 2
        }

        CheckBox {
            id: windowIconOnTheRight
            text: i18n("Window icon on the right")
            Layout.columnSpan: 2
        }

        Item {
            width: 2
            height: 10
            Layout.columnSpan: 2
        }

        GridLayout {
            columns: 2

            Layout.columnSpan: 2

            Item {
                width: 2
                height: 10
            }
            CheckBox {
                id: boldFontWeight
                text: i18n("Bold text")
            }

            Label {
                text: i18n('Text font:')
                Layout.alignment: Qt.AlignRight
            }
            ComboBox {
                id: fontFamilyComboBox
                // ComboBox's sizing is just utterly broken
                Layout.minimumWidth: units.gridUnit * 10
                model: fontsModel
                // doesn't autodeduce from model because we manually populate it
                textRole: "text"
                onCurrentIndexChanged: {
                    var current = model.get(currentIndex)
                    if (current) {
                        cfg_fontFamily = current.value
                        appearancePage.configurationChanged()
                        console.log('change: ' + cfg_fontFamily)
                    }
                }
            }

            Label {
                text: i18n("Icon and text spacing:")
                Layout.alignment: Qt.AlignVCenter|Qt.AlignRight
            }
            SpinBox {
                id: iconAndTextSpacing
                decimals: 1
                stepSize: 0.5
                minimumValue: 0.5
                maximumValue: 300
            }

            Label {
                text: i18n("Font size scale:")
                Layout.alignment: Qt.AlignVCenter|Qt.AlignRight
            }
            SpinBox {
                id: fontSizeScale
                decimals: 2
                stepSize: 0.05
                minimumValue: 0
                maximumValue: 3
            }

        }

    }

}
