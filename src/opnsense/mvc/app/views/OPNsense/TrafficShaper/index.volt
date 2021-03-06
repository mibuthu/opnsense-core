{#

OPNsense® is Copyright © 2014 – 2015 by Deciso B.V.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

1.  Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.

2.  Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED “AS IS” AND ANY EXPRESS OR IMPLIED WARRANTIES,
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

#}
<style>
    .hidden {
        display:none;
    }
</style>
<script type="text/javascript">

    $( document ).ready(function() {

        /*************************************************************************************************************
         * manage bandwidth pipes
         *************************************************************************************************************/

        /**
         * Render pipe grid using searchPipes api
         */
        var gridPipes = stdBootgridUI("grid-pipes", "/api/trafficshaper/settings/searchPipes");

        /**
         * Link pipe grid command controls (edit/delete)
         */
        gridPipes.on("loaded.rs.jquery.bootgrid", function(){
            // edit item
            gridPipes.find(".command-edit").on("click", function(e)
            {
                var uuid=$(this).data("row-id");
                mapDataToFormUI({'frm_DialogPipe':"/api/trafficshaper/settings/getPipe/"+uuid}).done(function(){
                    // update selectors
                    $('.selectpicker').selectpicker('refresh');
                    // clear validation errors (if any)
                    clearFormValidation('frm_DialogPipe');
                });

                // show dialog for pipe edit
                $('#DialogPipe').modal({backdrop: 'static', keyboard: false});
                // curry uuid to save action
                $("#btn_DialogPipe_save").unbind('click').click(savePipe.bind(undefined, uuid));
            }).end();

            // delete item
            gridPipes.find(".command-delete").on("click", function(e)
            {
                var uuid=$(this).data("row-id");
                stdDialogRemoveItem('Remove selected item?',function() {
                    ajaxCall(url="/api/trafficshaper/settings/delPipe/" + uuid,
                            sendData={},callback=function(data,status){
                        // reload grid after delete
                        $("#grid-pipes").bootgrid("reload");
                    });
                });
            }).end();
        });

        /**
         * save form data to end point for existing pipe
         */
        function savePipe(uuid) {
            saveFormToEndpoint(url="/api/trafficshaper/settings/setPipe/"+uuid,
                    formid="frm_DialogPipe", callback_ok=function(){
                        $("#DialogPipe").modal('hide');
                        $("#grid-pipes").bootgrid("reload");
                    });
        }

        /**
         * save form data to end point for new pipe
         */
        function addPipe() {
            saveFormToEndpoint(url="/api/trafficshaper/settings/addPipe/",
                    formid="frm_DialogPipe", callback_ok=function(){
                        $("#DialogPipe").modal('hide');
                        $("#grid-pipes").bootgrid("reload");
                    });
        }

        /**
         * Delete list of uuids on click event
         */
        $("#deletePipes").click(function(){
            stdDialogRemoveItem("Remove selected items?",function(){
                var rows =$("#grid-pipes").bootgrid('getSelectedRows');
                if (rows != undefined){
                    var deferreds = [];
                    $.each(rows, function(key,uuid){
                        deferreds.push(ajaxCall(url="/api/trafficshaper/settings/delPipe/" + uuid, sendData={},null));
                    });
                    // refresh after load
                    $.when.apply(null, deferreds).done(function(){
                        $("#grid-pipes").bootgrid("reload");
                    });
                }
            });
        });

        /**
         * Add new pipe on click event
         */
        $("#addPipe").click(function(){
            mapDataToFormUI({'frm_DialogPipe':"/api/trafficshaper/settings/getPipe/"}).done(function(){
                // update selectors
                $('.selectpicker').selectpicker('refresh');
                // clear validation errors (if any)
                clearFormValidation('frm_DialogPipe');
            });

            // show dialog for pipe edit
            $('#DialogPipe').modal({backdrop: 'static', keyboard: false});
            // curry uuid to save action
            $("#btn_DialogPipe_save").unbind('click').click(addPipe);

        });

        /*************************************************************************************************************
         * manage Queues
         *************************************************************************************************************/

        /**
         * Render queue grid using searchQueues api
         */
        var gridQueues = stdBootgridUI("grid-queues", "/api/trafficshaper/settings/searchQueues");

        /**
         * Link queue grid command controls (edit/delete)
         */
        gridQueues.on("loaded.rs.jquery.bootgrid", function(){
            // edit item
            gridQueues.find(".command-edit").on("click", function(e)
            {
                var uuid=$(this).data("row-id");
                mapDataToFormUI({'frm_DialogQueue':"/api/trafficshaper/settings/getQueue/"+uuid}).done(function(){
                    // update selectors
                    $('.selectpicker').selectpicker('refresh');
                    // clear validation errors (if any)
                    clearFormValidation('frm_DialogQueue');
                });

                // show dialog for queue edit
                $('#DialogQueue').modal({backdrop: 'static', keyboard: false});
                // curry uuid to save action
                $("#btn_DialogQueue_save").unbind('click').click(saveQueue.bind(undefined, uuid));
            }).end();

            // delete item
            gridQueues.find(".command-delete").on("click", function(e)
            {
                var uuid=$(this).data("row-id");
                stdDialogRemoveItem('Remove selected item?',function() {
                    ajaxCall(url="/api/trafficshaper/settings/delQueue/" + uuid,
                            sendData={},callback=function(data,status){
                                // reload grid after delete
                                $("#grid-queues").bootgrid("reload");
                            });
                });
            }).end();
        });

        /**
         * save form data to end point for existing queue
         */
        function saveQueue(uuid) {
            saveFormToEndpoint(url="/api/trafficshaper/settings/setQueue/"+uuid,
                    formid="frm_DialogQueue", callback_ok=function(){
                        $("#DialogQueue").modal('hide');
                        $("#grid-queues").bootgrid("reload");
                    });
        }

        /**
         * save form data to end point for new queue
         */
        function addQueue() {
            saveFormToEndpoint(url="/api/trafficshaper/settings/addQueue/",
                    formid="frm_DialogQueue", callback_ok=function(){
                        $("#DialogQueue").modal('hide');
                        $("#grid-queues").bootgrid("reload");
                    });
        }

        /**
         * Delete list of uuids on click event
         */
        $("#deleteQueues").click(function(){
            stdDialogRemoveItem("Remove selected items?",function(){
                var rows =$("#grid-queues").bootgrid('getSelectedRows');
                if (rows != undefined){
                    var deferreds = [];
                    $.each(rows, function(key,uuid){
                        deferreds.push(ajaxCall(url="/api/trafficshaper/settings/delQueue/" + uuid, sendData={},null));
                    });
                    // refresh after load
                    $.when.apply(null, deferreds).done(function(){
                        $("#grid-queues").bootgrid("reload");
                    });
                }
            });
        });

        /**
         * Add new queue on click event
         */
        $("#addQueue").click(function(){
            mapDataToFormUI({'frm_DialogQueue':"/api/trafficshaper/settings/getQueue/"}).done(function(){
                // update selectors
                $('.selectpicker').selectpicker('refresh');
                // clear validation errors (if any)
                clearFormValidation('frm_DialogQueue');
            });

            // show dialog for queue edit
            $('#DialogQueue').modal({backdrop: 'static', keyboard: false});
            // curry uuid to save action
            $("#btn_DialogQueue_save").unbind('click').click(addQueue);

        });


        /*************************************************************************************************************
         * manage rules
         *************************************************************************************************************/

        /**
         * save form data to end point for existing rule
         */
        function saveRule(uuid) {
            saveFormToEndpoint(url="/api/trafficshaper/settings/setRule/"+uuid,
                    formid="frm_DialogRule", callback_ok=function(){
                        $("#DialogRule").modal('hide');
                        $("#grid-rules").bootgrid("reload");
                    });
        }

        /**
         * save form data to end point for new pipe
         */
        function addRule() {
            saveFormToEndpoint(url="/api/trafficshaper/settings/addRule/",
                    formid="frm_DialogRule", callback_ok=function(){
                        $("#DialogRule").modal('hide');
                        $("#grid-rules").bootgrid("reload");
                    });
        }

        /**
         * Render rules grid using searchPipes api
         */
        var gridRules = stdBootgridUI("grid-rules", "/api/trafficshaper/settings/searchRules");

        /**
         * Link rule grid command controls (edit/delete)
         */
        gridRules.on("loaded.rs.jquery.bootgrid", function(){
            // edit item
            gridRules.find(".command-edit").on("click", function(e)
            {
                var uuid=$(this).data("row-id");
                mapDataToFormUI({'frm_DialogRule':"/api/trafficshaper/settings/getRule/"+uuid}).done(function(){
                    // update selectors
                    $('.selectpicker').selectpicker('refresh');
                    // clear validation errors (if any)
                    clearFormValidation('frm_DialogRule');
                });

                // show dialog for pipe edit
                $('#DialogRule').modal({backdrop: 'static', keyboard: false});
                // curry uuid to save action
                $("#btn_DialogRule_save").unbind('click').click(saveRule.bind(undefined, uuid));
            }).end();

            // delete item
            gridRules.find(".command-delete").on("click", function(e)
            {
                var uuid = $(this).data("row-id");
                stdDialogRemoveItem("Remove selected item?",function(){
                    ajaxCall(url="/api/trafficshaper/settings/delRule/" + uuid,
                            sendData={},callback=function(data,status){
                        // reload grid after delete
                        $("#grid-rules").bootgrid("reload");
                    });
                });
            }).end();
        });

        /**
         * Add new rule on click event
         */
        $("#addRule").click(function(){
            mapDataToFormUI({'frm_DialogRule':"/api/trafficshaper/settings/getRule/"}).done(function(){
                // update selectors
                $('.selectpicker').selectpicker('refresh');
                // clear validation errors (if any)
                clearFormValidation('frm_DialogRule');
            });

            // show dialog for pipe edit
            $('#DialogRule').modal({backdrop: 'static', keyboard: false});
            // curry uuid to save action
            $("#btn_DialogRule_save").unbind('click').click(addRule);

        });

        /**
         * Delete list of uuids on click event
         */
        $("#deleteRules").click(function(){
            stdDialogRemoveItem("Remove selected items?",function(){
                var rows =$("#grid-rules").bootgrid('getSelectedRows');
                if (rows != undefined){
                    var deferreds = [];
                    $.each(rows, function(key,uuid){
                        deferreds.push(ajaxCall(url="/api/trafficshaper/settings/delRule/" + uuid, sendData={},null));
                    });
                    // refresh after load
                    $.when.apply(null, deferreds).done(function(){
                        $("#grid-rules").bootgrid("reload");
                    });
                }
            });
        });


        /*************************************************************************************************************
         * Commands
         *************************************************************************************************************/

        /**
         * Reconfigure ipfw / trafficshaper
         */
        $("#reconfigureAct").click(function(){
            $("#reconfigureAct_progress").addClass("fa fa-spinner fa-pulse");
            ajaxCall(url="/api/trafficshaper/service/reconfigure", sendData={}, callback=function(data,status) {
                // when done, disable progress animation.
                $("#reconfigureAct_progress").removeClass("fa fa-spinner fa-pulse");

                if (status != "success" || data['status'] != 'ok') {
                    BootstrapDialog.show({
                        type: BootstrapDialog.TYPE_WARNING,
                        title: "Error reconfiguring trafficshaper",
                        message: data['status'],
                        draggable: true
                    });
                }
            });
        });

    });


</script>

<div class="container-fluid">
    <div class="row">
        <div class="col-md-12">
            <ul class="nav nav-tabs" data-tabs="tabs" id="maintabs">
                <li class="active"><a data-toggle="tab" href="#pipes">{{ lang._('Pipes') }}</a></li>
                <li><a data-toggle="tab" href="#queues">{{ lang._('Queues') }}</a></li>
                <li><a data-toggle="tab" href="#rules">{{ lang._('Rules') }}</a></li>
            </ul>
            <div class="tab-content">
                <div id="pipes" class="tab-pane fade in active">
                    <!-- tab page "pipes" -->
                    <table id="grid-pipes" class="table table-condensed table-hover table-striped table-responsive">
                        <thead>
                        <tr>
                            <th data-column-id="origin" data-type="string" data-visible="false">Origin</th>
                            <th data-column-id="number" data-type="number"  data-visible="false">Number</th>
                            <th data-column-id="bandwidth" data-type="number">Bandwidth</th>
                            <th data-column-id="bandwidthMetric" data-type="string">BandwidthMetric</th>
                            <th data-column-id="mask" data-type="string">Mask</th>
                            <th data-column-id="description" data-type="string">Description</th>
                            <th data-column-id="commands" data-formatter="commands" data-sortable="false">Commands</th>
                            <th data-column-id="uuid" data-type="string" data-identifier="true"  data-visible="false">ID</th>
                        </tr>
                        </thead>
                        <tbody>
                        </tbody>
                        <tfoot>
                        <tr>
                            <td></td>
                            <td>
                                <button type="button" id="addPipe" class="btn btn-xs btn-default"><span class="fa fa-pencil"></span></button>
                                <button type="button" id="deletePipes" class="btn btn-xs btn-default"><span class="fa fa-trash-o"></span></button>
                            </td>
                        </tr>
                        </tfoot>
                    </table>
                </div>
                <div id="queues" class="tab-pane fade in">
                    <!-- tab page "queues" -->
                    <table id="grid-queues" class="table table-condensed table-hover table-striped table-responsive">
                        <thead>
                        <tr>
                            <th data-column-id="origin" data-type="string" data-visible="false">Origin</th>
                            <th data-column-id="number" data-type="number" data-visible="false">Number</th>
                            <th data-column-id="pipe" data-type="string">Pipe</th>
                            <th data-column-id="weight" data-type="string">Weight</th>
                            <th data-column-id="description" data-type="string">Description</th>
                            <th data-column-id="commands" data-formatter="commands" data-sortable="false">Commands</th>
                            <th data-column-id="uuid" data-type="string" data-identifier="true"  data-visible="false">ID</th>
                        </tr>
                        </thead>
                        <tbody>
                        </tbody>
                        <tfoot>
                        <tr>
                            <td></td>
                            <td>
                                <button type="button" id="addQueue" class="btn btn-xs btn-default"><span class="fa fa-pencil"></span></button>
                                <button type="button" id="deleteQueues" class="btn btn-xs btn-default"><span class="fa fa-trash-o"></span></button>
                            </td>
                        </tr>
                        </tfoot>
                    </table>
                </div>
                <div id="rules" class="tab-pane fade in">
                    <!-- tab page "rules" -->
                    <table id="grid-rules" class="table table-condensed table-hover table-striped table-responsive">
                        <thead>
                        <tr>
                            <th data-column-id="sequence" data-type="number">#</th>
                            <th data-column-id="origin" data-type="string"  data-visible="false">Origin</th>
                            <th data-column-id="interface" data-type="string">Interface</th>
                            <th data-column-id="proto" data-type="string">Protocol</th>
                            <th data-column-id="source" data-type="string">Source</th>
                            <th data-column-id="destination" data-type="string">Destination</th>
                            <th data-column-id="target" data-type="string">Target</th>
                            <th data-column-id="description" data-type="string">Description</th>
                            <th data-column-id="commands" data-formatter="commands" data-sortable="false">Commands</th>
                            <th data-column-id="uuid" data-type="string" data-identifier="true"  data-visible="false">ID</th>
                        </tr>
                        </thead>
                        <tbody>
                        </tbody>
                        <tfoot>
                        <tr >
                            <td></td>
                            <td>
                                <button type="button" id="addRule" class="btn btn-xs btn-default"><span class="fa fa-pencil"></span></button>
                                <button type="button" id="deleteRules" class="btn btn-xs btn-default"><span class="fa fa-trash-o"></span></button>
                            </td>
                        </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <button class="btn btn-primary"  id="reconfigureAct" type="button"><b>Apply</b><i id="reconfigureAct_progress" class=""></i></button>
        </div>
    </div>
</div>


{# include dialogs #}
{{ partial("layout_partials/base_dialog",['fields':formDialogPipe,'id':'DialogPipe','label':'Edit pipe'])}}
{{ partial("layout_partials/base_dialog",['fields':formDialogQueue,'id':'DialogQueue','label':'Edit queue'])}}
{{ partial("layout_partials/base_dialog",['fields':formDialogRule,'id':'DialogRule','label':'Edit rule'])}}

