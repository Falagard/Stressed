package ;

import haxe.ui.containers.VBox;
import haxe.ui.events.MouseEvent;

@:build(haxe.ui.ComponentBuilder.build("Assets/main-view.xml"))
class MainView extends VBox {

    private var serverAddress:String = "http://127.0.0.1:8000/hello";


    public function new() {
        super();
    }       

    @:bind(onRunTestButton, MouseEvent.CLICK)
    private function onRunTestButtonClicked(e:MouseEvent) {
        var tester = new StressTester(serverAddress, 100, 10);
        tester.start();
    }
}

