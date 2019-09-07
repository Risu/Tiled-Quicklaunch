import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.private.kicker 0.1 as Kicker
import org.kde.kcoreaddons 1.0 as KCoreAddons

import "lib"

Item {
	id: widget

	Logger {
		id: logger
		name: 'tiledmenu'
		// showDebug: true
	}

	property alias rootModel: appsModel.rootModel
	AppsModel {
		id: appsModel
	}

	// Workaround for passing the favoriteId to the drop handler.
	// Use until event.mimeData.mimeData is exposed.
	// https://github.com/KDE/kdeclarative/blob/0e47f91b3a2c93655f25f85150faadad0d65d2c1/src/qmlcontrols/draganddrop/DeclarativeDragDropEvent.cpp#L66
	property string draggedFavoriteId: ""
	// onDraggedFavoriteIdChanged: console.log('onDraggedFavoriteIdChanged', draggedFavoriteId)


	AppletConfig {
		id: config
	}

	function logListModel(label, listModel) {
		console.log(label + '.count', listModel.count);
		// logObj(label, listModel);
		for (var i = 0; i < listModel.count; i++) {
			var item = listModel.modelForRow(i);
			var itemLabel = label + '[' + i + ']';
			console.log(itemLabel, item);
			logObj(itemLabel, item);
			if (('' + item).indexOf('Model') >= 0) {
				logListModel(itemLabel, item);
			}
		}
	}
	function logObj(label, obj) {
		// if (obj && typeof obj === 'object') {
		//  console.log(label, Object.keys(obj))
		// }
		
		for (var key in obj) {
			var val = obj[key];
			if (typeof val !== 'function') {
				var itemLabel = label + '.' + key;
				console.log(itemLabel, typeof val, val);
				if (('' + val).indexOf('Model') >= 0) {
					logListModel(itemLabel, val);
				}
			}
		}
	}

	Plasmoid.toolTipMainText: i18n("Show hidden icons")
	Plasmoid.toolTipSubText: ""

	Plasmoid.compactRepresentation: LauncherIcon {
		id: panelItem
		iconSource: plasmoid.configuration.icon || Qt.resolvedUrl("../icons/quicklaunch2.png") 
	}

	Plasmoid.hideOnWindowDeactivate: !plasmoid.userConfiguring
	property bool expanded: plasmoid.expanded

	// width: popup.width
	// height: popup.height
	PlasmaCore.Dialog {
        id: popup
        type: PlasmaCore.Dialog.PopupMenu
        flags: Qt.WindowStaysOnTopHint
        hideOnWindowDeactivate: true
        location: plasmoid.location
        visualParent: plasmoid
        
        mainItem: Popup { } 
    }
	
	//Layout.minimumWidth: config.leftSectionWidth
	//Layout.preferredWidth: config.popupWidth
	//Layout.preferredHeight: config.popupHeight

	// Layout.minimumHeight: 600 // For quickly testing as a desktop widget
	// Layout.minimumWidth: 800

	// Layout.onPreferredWidthChanged: console.log('popup.size', width, height)
	// Layout.onPreferredHeightChanged: console.log('popup.size', width, height)

	function action_kinfocenter() { appsModel.launch('org.kde.kinfocenter') }
	function action_konsole() { appsModel.launch('org.kde.konsole') }
	function action_ksysguard() { appsModel.launch('org.kde.ksysguard') }
	function action_systemsettings() { appsModel.launch('systemsettings') }
	function action_filemanager() { appsModel.launch('org.kde.dolphin') }
	function action_menuedit() { processRunner.runMenuEditor(); }

	Component.onCompleted: {
		if (plasmoid.hasOwnProperty("activationTogglesExpanded")) {
			plasmoid.activationTogglesExpanded = true
		}
		/*plasmoid.setAction("kinfocenter", i18n("System Info"), "hwinfo");
		plasmoid.setAction("konsole", i18n("Terminal"), "utilities-terminal");
		plasmoid.setActionSeparator("systemAppsSection")
		plasmoid.setAction("ksysguard", i18n("Task Manager"), "ksysguardd");
		plasmoid.setAction("systemsettings", i18n("System Settings"), "systemsettings");
		plasmoid.setAction("filemanager", i18n("File Manager"), "folder");
		plasmoid.setActionSeparator("configSection")
		plasmoid.setAction("menuedit", i18n("Edit Applications..."), "kmenuedit");*/

		// plasmoid.action('configure').trigger() // Uncomment to open the config window on load.
	}
}
