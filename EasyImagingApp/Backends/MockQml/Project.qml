// SPDX-FileCopyrightText: 2024 EasyApp contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

pragma Singleton

import QtQuick

QtObject {

    property bool created: false

    property string name: ''

    property var info: {
        'description': '',
        'location': '',
        'creationDate': ''
    }

    readonly property var examples: [
        {
            'description': 'Iron powder, SENJU@J-PARC',
            'name': 'Fe (alpha) (SENJU)',
            'path': ':/examples/iron.tiff'
        }
    ]

    function create() {
        console.debug(`Creating project '${name}'`)
        info.creationDate = `${new Date().toLocaleDateString()} ${new Date().toLocaleTimeString()}`
        infoChanged()  // this signal is not emitted automatically when only part of the object is changed
        created = true
    }

    function save() {
        console.debug(`NOT IMPLEMENTED: Saving project '${name}'`)
    }

    function editInfo(path, new_value) {
        console.debug(`NOT IMPLEMENTED: Changing project info.${path} from '${info.path}' to '${new_value}'`)
    }

    function load(file_path) {
        console.debug(`Loading project from '${file_path}'`)
        info.creationDate = `${new Date().toLocaleDateString()} ${new Date().toLocaleTimeString()}`
        created = true
    }

}
