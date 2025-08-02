import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Window 2.0

ApplicationWindow{
    id: app
    visible: true
    visibility: 'Maximized'
    color: 'black'
    title: 'Unikey Ejemplo Sqlite'
    property int fs: Screen.width*0.02
    Item{
        id: xApp
        width: Screen.width
        anchors.fill: parent
        Column{
            spacing: app.fs*0.25
            anchors.centerIn: parent
            Rectangle{
                id: xCab
                width: parent.width
                height: app.fs*1.5
                color: 'black'
                border.width: 1
                border.color: 'white'
                Text{
                    text: '<b>'+app.title+' - Lista de Productos</b>'
                    font.pixelSize: app.fs
                    color: 'white'
                    anchors.centerIn: parent
                }
            }
            Rectangle{
                id: xLv
                width: xApp.width
                height: colCab.height+app.fs
                color: 'black'
                border.width: 1
                border.color: 'white'
                Column{
                    id: colCab
                    anchors.centerIn: parent
                    Row{
                        id: rowCab
                        anchors.horizontalCenter: parent.horizontalCenter
                        Repeater{
                            id: repCab
                            Rectangle{
                                width: 100
                                height: app.fs*1.5
                                color: 'white'
                                border.width: 3
                                border.color: 'gray'
                                Text{
                                    text: '<b>'+modelData+'</b>'
                                    font.pixelSize: app.fs
                                    color: 'black'
                                    anchors.centerIn: parent
                                    //visible: contentWidth<parent.width-app.fs*0.25
                                    Timer{
                                        running: parent.contentWidth>=parent.parent.width-app.fs*0.25
                                        repeat: true
                                        interval: 50
                                        onTriggered: parent.font.pixelSize-=2
                                    }
                                }
                            }
                        }
                    }
                    ListView{
                        id: lv
                        width: xApp.width
                        height: xApp.height-xCab.height-xBtns.height-app.fs*2
                        model: lm
                        delegate: compLvRow
                        clip: true
                        ListModel{
                            id: lm
                            function add(datos){
                                return{
                                    d0: datos[0],
                                    d1: datos[1],
                                    d2: datos[2],
                                    d3: datos[3],
                                    d4: datos[4]
                                }
                            }
                        }
                    }
                }
            }
            Rectangle{
                id: xBtns
                width: parent.width
                height: col2.height+app.fs
                color: 'black'
                border.width: 1
                border.color: 'white'
                Column{
                    id: col2
                    spacing: app.fs*0.25
                    anchors.centerIn: parent
                    Item{width: 1; height: app.fs}
                    Row{
                        id: rowTiInsDatos
                        spacing: app.fs//*0.25
                        Repeater{
                            id: repTiInsDatos
                            Item{
                                id: xTi
                                width: 100
                                height: app.fs*1.5
                                visible: index>0
                                Text{
                                    text: modelData
                                    color: 'white'
                                    anchors.bottom: parent.top
                                    anchors.bottomMargin: app.fs*0.1
                                }
                                Rectangle{
                                    width: parent.width+app.fs*0.25
                                    height: app.fs*1.5
                                    color: 'black'
                                    border.width: 3
                                    border.color: 'white'
                                    clip: true
                                    SequentialAnimation on border.color{
                                        running: tiDato.focus
                                        loops: Animation.Infinite
                                        ColorAnimation {
                                            from: "yellow"
                                            to: "red"
                                            duration: 250
                                        }
                                        ColorAnimation {
                                            from: "red"
                                            to: "yellow"
                                            duration: 250
                                        }
                                    }
                                    TextInput{
                                        id: tiDato
                                        width: parent.width-4
                                        height: parent.height-4
                                        font.pixelSize: height*0.8
                                        color: 'white'
                                        anchors.centerIn: parent
                                        //Keys.onTabPressed: toTab(false)
                                        Keys.onEnterPressed: toTab(false)
                                        Keys.onReturnPressed: toTab(false)
                                        DoubleValidator {
                                            id: dv
                                            decimals: 2
                                            notation: DoubleValidator.StandardNotation
                                        }

                                    }
                                }
                                Component.onCompleted: {
                                    if(index===1){
                                        xTi.width=app.fs*6
                                    }
                                    if(index===2){
                                        xTi.width=app.fs*20
                                    }
                                    if(index===3){
                                        xTi.width=app.fs*6
                                    }
                                    if(index===4){
                                        xTi.width=app.fs*6
                                        tiDato.validator=dv
                                    }
                                }
                            }
                        }
                        Button{
                            id: botInsertar
                            text: 'Insertar'
                            anchors.verticalCenter: parent.verticalCenter
                            onClicked: {
                                let nom=rowTiInsDatos.children[1].children[1].children[0].text
                                let des=rowTiInsDatos.children[2].children[1].children[0].text
                                let cat=rowTiInsDatos.children[3].children[1].children[0].text
                                let pre=rowTiInsDatos.children[4].children[1].children[0].text
                                if(nom!==''&&des!==''&&cat!==''&&pre!==''){
                                    let ins=insertarDatos(nom, des, cat, pre)
                                    if(!ins){
                                        xMsg.msg='Hubo un error!\n\nNo se pudo guardar el dato: ['+nom+', '+des+', '+cat+', '+pre+'].'
                                        return
                                    }
                                    recargarLista('DESC')
                                    rowTiInsDatos.children[1].children[1].children[0].focus=true
                                }else{
                                    xMsg.msg='Error!\nPara redistrar un dato hay que llenar todos los campos de texto.'
                                }

                            }
                            Rectangle{
                                width: parent.width+border.width*2
                                height: parent.height+border.width*2
                                color: 'transparent'
                                border.width: 3
                                border.color: 'white'
                                clip: true
                                SequentialAnimation on border.color{
                                    running: botInsertar.focus
                                    loops: Animation.Infinite
                                    ColorAnimation {
                                        from: "yellow"
                                        to: "red"
                                        duration: 250
                                    }
                                    ColorAnimation {
                                        from: "red"
                                        to: "yellow"
                                        duration: 250
                                    }
                                }
                            }
                        }
                    }
                    Row{
                        Button{
                            text: 'Eliminar Todo'
                            onClicked: eliminarTodo()
                        }
                    }
                }
            }
        }
        Item{
            id: xMsg
            anchors.fill: parent
            property string title: app.title+' - Informa'
            property string msg: ''
            visible: msg!==''
            MouseArea{
                anchors.fill: parent
                onClicked: msg+='\nPresione Aceptar para cerrar.'
            }
            Rectangle{
                color: 'black'
                opacity: 0.65
                anchors.fill: parent
            }
            Rectangle{
                width: app.fs*20
                height: colMsg.height+app.fs
                color: 'black'
                border.width: 2
                border.color: 'white'
                radius: app.fs*0.5
                anchors.centerIn: parent
                Column{
                    id: colMsg
                    spacing: app.fs*0.5
                    anchors.centerIn: parent
                    Text{
                        width: app.fs*19
                        text: xMsg.title
                        font.pixelSize: app.fs*0.5
                        color: 'white'
                    }
                    Text{
                        id: txtMsg
                        width: app.fs*19
                        text: xMsg.msg
                        font.pixelSize: app.fs*0.5
                        color: 'white'
                        wrapMode: Text.WordWrap
                    }
                    Button{
                        text: 'Aceptar'
                        font.pixelSize: app.fs*0.5
                        anchors.right: parent.right
                        onClicked: xMsg.msg=''
                    }
                }
            }

        }
    }
    Component{
        id: compLvRow
        Rectangle{
            id: xItem
            width: lv.width
            height: app.fs*1.2
            color: lv.currentIndex===index?'white':'black'
            border.width: 1
            border.color: !lv.currentIndex===index?'white':'gray'
            property var aAnchos: [100,500,100,100,100]
            property bool selected: lv.currentIndex===index
            MouseArea{
                anchors.fill: parent
                onClicked: lv.currentIndex=index
            }
            Row{
                id: row2
                Repeater{
                    id: rep
                    Rectangle{
                        width: rowCab.children[index].width
                        height: app.fs*1.2
                        color: xItem.selected?'white':'black'
                        border.width: 1
                        border.color: !xItem.selected?'white':'black'
                        clip: true
                        Text{
                            id: txt
                            text: modelData//'aa->'+d//xItem.aRowData[0]//rwp.model[index]
                            font.pixelSize: app.fs
                            color: !xItem.selected?'white':'black'
                            anchors.centerIn: parent
                            visible: contentWidth<parent.width-app.fs*0.25
                            Timer{
                                running: parent.contentWidth>=parent.parent.width-app.fs*0.25
                                repeat: true
                                interval: 50
                                onTriggered: parent.font.pixelSize-=2
                            }
                        }
                    }
                }
            }
            Component.onCompleted: {
                rep.model=[d0, d1, d2, d3, '$'+parseFloat(d4).toFixed(2)]
            }
        }
    }
    Component.onCompleted: {
        let aColName=['id', 'Nombre', 'Descripción', 'Categoría', 'Precio']
        repCab.model=aColName
        repTiInsDatos.model=aColName

        rowCab.children[0].width=Screen.width*0.1
        rowCab.children[1].width=Screen.width*0.3
        rowCab.children[2].width=Screen.width*0.3
        rowCab.children[3].width=Screen.width*0.2
        rowCab.children[4].width=Screen.width*0.1

        let sqliteFile=unik.currentFolderPath()+'/ejemplo.sqlite'
        unik.sqliteInit(sqliteFile)

        //CREAR TABLA
        let tableName = "productos";
        let sql = '
                CREATE TABLE IF NOT EXISTS '+tableName+' (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    nom TEXT NOT NULL,
                    des TEXT,
                    cat TEXT,
                    pre REAL
                );
            '
        let q = unik.sqlQuery(sql)
        console.log('q1: '+q)



        recargarLista('ASC')
    }
    Shortcut{
        sequence: 'Enter'
        onActivated: {
            if(botInsertar.focus){
                botInsertar.clicked()
            }
        }
    }
    Shortcut{
        sequence: 'Return'
        onActivated: {
            if(botInsertar.focus){
                botInsertar.clicked()
            }
        }
    }
    Shortcut{
        sequence: 'Tab'
        onActivated: {
            toTab(false)
        }
    }
    Shortcut{
        sequence: 'Esc'
        onActivated: {
            Qt.quit()
        }
    }
    Shortcut{
        sequence: 'Down'
        onActivated: {
            if(lv.currentIndex<lm.count){
                lv.currentIndex++
            }else{
                lv.currentIndex=0
            }
        }
    }
    Shortcut{
        sequence: 'Up'
        onActivated: {
            if(lv.currentIndex>0){
                lv.currentIndex--
            }else{
                lv.currentIndex=lm.count-1
            }
        }
    }
    function recargarLista(orden){
        lm.clear()
        let tableName = "productos";
        let o='ORDER BY id '+orden+''

        let sql = 'SELECT * FROM '+tableName+' '+o
        let filas = unik.getSqlData(sql);

        for(var i=0;i<filas.length;i++){
            let row=[]
            for(var i2=0;i2<filas[i].col.length;i2++){
                row.push(filas[i].col[i2])
            }
            lm.append(lm.add(row))
        }
    }
    function insertarDatos(nom, des, cat, pre){
        let tableName = "productos";
        let sql = '
                INSERT INTO '+tableName+' (nom, des, cat, pre)
                VALUES (\''+nom+'\', \''+des+'\', \''+cat+'\', '+pre+');
            '
        return unik.sqlQuery(sql)
    }
    function eliminarTodo(){
        const tableName = "productos";
        let sql = 'DELETE FROM '+tableName
        let q = unik.sqlQuery(sql)
        recargarLista('ASC')
    }
    function toTab(ctrl){
        if(!ctrl){
            if(rowTiInsDatos.children[1].children[1].children[0].focus){
                rowTiInsDatos.children[2].children[1].children[0].focus=true
            }else if(rowTiInsDatos.children[2].children[1].children[0].focus){
                rowTiInsDatos.children[3].children[1].children[0].focus=true
            }else if(rowTiInsDatos.children[3].children[1].children[0].focus){
                rowTiInsDatos.children[4].children[1].children[0].focus=true
            }else if(rowTiInsDatos.children[4].children[1].children[0].focus){
                botInsertar.focus=true
            }else{
                rowTiInsDatos.children[1].children[1].children[0].focus=true
            }
        }
    }
}
