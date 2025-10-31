package;

import haxe.Http;
import haxe.Timer;
import sys.thread.Thread;

class StressTester {
    public var url:String;
    public var totalRequests:Int;
    public var concurrency:Int;
    public var completed:Int = 0;
    public var failed:Int = 0;
    public var timings:Array<Float> = [];

    public function new(url:String, totalRequests:Int, concurrency:Int) {
        this.url = url;
        this.totalRequests = totalRequests;
        this.concurrency = concurrency;
    }

    public function start():Void {
        var running:Int = 0;
        var sent:Int = 0;
        var self = this;
        function sendRequest() {
            if (sent >= totalRequests) return;
            sent++;
            running++;
            var startTime = Timer.stamp();
            var http = new Http(url);
            http.onData = function(data) {
                var elapsed = Timer.stamp() - startTime;
                timings.push(elapsed);
                completed++;
                running--;
                trace(data);
                if (sent < totalRequests) sendRequest();
            };
            http.onError = function(error) {
                failed++;
                running--;
                trace(error);
                if (sent < totalRequests) sendRequest();
            };
            http.request(false);
        }
        for (i in 0...concurrency) sendRequest();
    }

    public function report():Void {
        trace('Completed: ' + completed);
        trace('Failed: ' + failed);
        if (timings.length > 0) {
            var sum = 0.0;
            for (t in timings) sum += t;
            var avg = sum / timings.length;
            trace('Average response time: ' + avg + ' seconds');
        }
    }
}
