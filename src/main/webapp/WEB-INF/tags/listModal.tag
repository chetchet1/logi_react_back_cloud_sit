<%@ tag body-content="empty" pageEncoding="utf-8" %>

<%--List Modal--%>
<div class="modal fade" id="listModal" role="dialog">
    <div class="modal-dialog">
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="listModalTitle">바뀔거에요</h5>
                <button type="button" class="close" data-dismiss="modal" style="padding-top: 0.5px">&times;</button>
            </div>
            <div class="modal-body">
            	<div id="listGrid" class="ag-theme-balham" style="height:500px;width:auto; margin-bottom:10px">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
