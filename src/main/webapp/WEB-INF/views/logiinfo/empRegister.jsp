<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>사원 등록</title>
<style>
.empBasicInfoFieldset {
	display: inline;
	width: 100px;
	margin-bottom: 15px;
	transition: 5s;
	outline: none;
	height: 30px;
	font-size: 15px;
	text-align: center;
}

#userIdInputBox, #empCodeInputBox, #userPasswordInputBox {
	display: inline;
	width: 150px;
	transition: 0.6s;
	outline: none;
	height: 30px;
	font-size: 20px;
	text-align: center;
}
.l1 {
	color: #FFFFFF;
}
legend {
	color: #FFFFFF;
.ui-datepicker {
	z-index: 9999 !important;
}

.ui-dialog {
	z-index: 9999 !important;
	font-size: 12px;
}

#searchAddressValueInputBox, #searchAddressMainNumberInputBox {
	display: inline;
	width: 140px;
	transition: 0.6s;
	outline: none;
	height: 25px;
	font-size: 15x;
	text-align: center;
	margin-top: 10px;
	margin-bottom: 10px;
}

.guidanceMsg {
	font-size: 16px;
	margin-top: 10px;
	margin-bottom: 10px;
}

.searchAddressLabel {
	font-size: 16px;
	margin-top: 10px;
	margin-bottom: 10px;
}

#error-dialog {
	z-index: 10002 !important;
	display: none;
	font-size: 1.1em;
	color: black;
}
</style>
<script>
	var previousCellValue; // 수정 가능한 셀에서 수정 전의 셀 값 
	var resultList = []; // 최종적으로 컨트롤러로 보내는 JS 객체 배열 

	var checkUserIdDuplicationStatus; // 사용자 id 중복체크 여부
	var checkEmpCodeDuplicationStatus; // 사원코드 중복체크 여부

	var chkcell = {
		cellId : undefined,
		chkval : undefined
	}; // addressGrid 에서 cnt 컬럼의 cell rowspan 중복 체크

	$(document).ready(
			function() {

				$.datepicker.setDefaults({
					dateFormat : 'yy-mm-dd',
					prevText : '이전 달',
					nextText : '다음 달',
					monthNames : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월',
							'8월', '9월', '10월', '11월', '12월' ],
					monthNamesShort : [ '1월', '2월', '3월', '4월', '5월', '6월',
							'7월', '8월', '9월', '10월', '11월', '12월' ],
					dayNames : [ '일', '월', '화', '수', '목', '금', '토' ],
					dayNamesShort : [ '일', '월', '화', '수', '목', '금', '토' ],
					dayNamesMin : [ '일', '월', '화', '수', '목', '금', '토' ],
					showMonthAfterYear : true,
					yearSuffix : '년'
				}); /*한글로 달력 보이기 위해서 */

				$("input[type=button], input[type=submit], input[type=file]")
						.button(); // jqueryUI Button 위젯 적용
				$("input[type=radio]").checkboxradio(); // jqueryUI Checkboxradio 위젯 적용

				initGrid();

				initEvent();

				$('#checkUserIdDialog').hide();
				$('#checkEmpCodeDialog').hide();
				$('#addressDialog').hide();

				$('#empBasicInfoGrid').addRowData(1, {
					status : "INSERT",
					userOrNot : "Y",
					companyCode : "${sessionScope.companyCode}"
				});

				$('#empDetailInfoGrid').addRowData(1, {
					status : "INSERT",
					companyCode : "${sessionScope.companyCode}",
					seq : "1",
					updateHistory : "신규가입"
				});

			});

	function initGrid() {

		// 사원 기본정보 그리드 시작
		$('#empBasicInfoGrid')
				.jqGrid(
						{
							mtype : 'POST',
							datatype : 'local',
							colNames : [ "사원코드", "사원명", "사원영문명", "주민등록번호",
									"입사일자", "생년월일", "성별", "status",
									"userOrNot", "companyCode" ],
							colModel : [
									{
										name : "empCode",
										width : "80",
										resizable : true,
										align : "center"
									},
									{
										name : "empName",
										width : "80",
										resizable : true,
										align : "center",
										editable : true
									},
									{
										name : "empEngName",
										width : "140",
										resizable : true,
										align : "center",
										editable : true
									},
									{
										name : "socialSecurityNumber",
										width : "120",
										resizable : true,
										align : "center",
										editable : true
									},
									{
										name : "hireDate",
										width : "70",
										resizable : true,
										align : "center",
										editable : true,
										//				  formatter: 'date',   => 주석 처리 : 여기 지정되면 사용자가 값을 미입력시 걸러주지 못함
										//				  formatoptions: { srcformat: 'ISO8601Long', newformat: 'Y-m-d' },  
										edittype : 'text',
										editoptions : {
											size : 12,
											maxlengh : 12,
											dataInit : function(element) {
												$(element)
														.datepicker(
																{
																	changeMonth : true,
																	numberOfMonths : 1,
																	onClose : function(
																			dateText,
																			datepicker) {
																		$(
																				'#empBasicInfoGrid')
																				.editCell(
																						1,
																						5,
																						false);
																	}
																})
											}
										},
										editrules : {
											date : true
										}
									},
									{
										name : "birthDate",
										width : "70",
										resizable : true,
										align : "center",
										editable : true,
										//				  formatter: 'date',   => 주석 처리 : 여기 지정되면 사용자가 값을 미입력시 걸러주지 못함
										//				  formatoptions: { srcformat: 'ISO8601Long', newformat: 'Y-m-d' },  
										edittype : 'text',
										editoptionTs : {
											size : 12,
											maxlengh : 12,
											dataInit : function(element) {
												$(element)
														.datepicker(
																{
																	changeMonth : true,
																	numberOfMonths : 1,
																	onClose : function(
																			dateText,
																			datepicker) {
																		$(
																				'#empBasicInfoGrid')
																				.editCell(
																						1,
																						6,
																						false);
																	}
																})
											}
										},
										editrules : {
											date : true
										}
									}, {
										name : "gender",
										width : "70",
										resizable : true,
										align : "center",
										editable : true
									}, {
										name : "status",
										width : "80",
										resizable : true,
										align : "center"
									}, {
										name : "userOrNot",
										width : "80",
										resizable : true,
										align : "center",
										hidden : true
									}, {
										name : "companyCode",
										width : "70",
										resizable : true,
										align : "center",
										hidden : true
									} ],
							caption : '사원 기본정보 등록',
							sortname : 'seq',
							multiselect : false,
							multiboxonly : false,
							viewrecords : false,
							height : 70,
							width : 1100,
							autowidth : false,
							shrinkToFit : false,
							cellEdit : true,
							rowNum : 10,
							scrollerbar : true,
							//rowList : [ 10, 20, 30 ],
							viewrecords : true,
							editurl : 'clientArray',
							cellsubmit : 'clientArray',
							autoencode : true,
							resizable : true,
							loadtext : '로딩중...',
							emptyrecords : '데이터가 없습니다.',
							cache : false,

							onCellSelect : function(rowid, iCol,
									previousCellValue, e) {

								if (iCol == 0) { // 사원코드 cell 클릭

									checkEmpCodeDuplication(this, rowid, iCol);

								}
							}
						}); // 사원 기본정보 그리드 끝

		// 사원 세부정보 그리드 시작
		$('#empDetailInfoGrid')
				.jqGrid(
						{
							mtype : 'POST',
							datatype : 'local',
							colNames : [ "사업장코드", "부서코드", "직급코드", "사용자ID",
									"비밀번호", "전화번호", "email", "우편번호", "기본주소",
									"상세주소", "최종학력", "status", "companyCode",
									"empCode", "seq", "updateHistory",
									"updateDate", "image" ],
							colModel : [

							{
								name : "workplaceCode",
								width : "75",
								resizable : true,
								align : "center"
							}, {
								name : "deptCode",
								width : "75",
								resizable : true,
								align : "center"
							}, {
								name : "positionCode",
								width : "75",
								resizable : true,
								align : "center"
							}, {
								name : "userId",
								width : "75",
								resizable : true,
								align : "center"
							}, {
								name : "userPassword",
								width : "75",
								resizable : true,
								align : "center"
							}, {
								name : "phoneNumber",
								width : "100",
								resizable : true,
								align : "center",
								editable : true
							}, {
								name : "email",
								width : "120",
								resizable : true,
								align : "center",
								editable : true
							}, {
								name : "zipCode",
								width : "80",
								resizable : true,
								align : "center"
							}, {
								name : "basicAddress",
								width : "300",
								resizable : true,
								align : "center"
							}, {
								name : "detailAddress",
								width : "140",
								resizable : true,
								align : "center",
								editable : true
							}, {
								name : "levelOfEducation",
								width : "75",
								resizable : true,
								align : "center",
								editable : true
							}, {
								name : "status",
								width : "80",
								resizable : true,
								align : "center"
							}, {
								name : "companyCode",
								width : "90",
								resizable : true,
								align : "center",
								hidden : true
							}, {
								name : "empCode",
								width : "70",
								resizable : true,
								align : "center",
								hidden : true
							}, {
								name : "seq",
								width : "70",
								resizable : true,
								align : "center",
								hidden : true
							}, {
								name : "updateHistory",
								width : "90",
								resizable : true,
								align : "center",
								hidden : true
							}, {
								name : "updateDate",
								width : "90",
								resizable : true,
								align : "center",
								hidden : true
							}, {
								name : "image",
								width : "70",
								resizable : true,
								align : "center",
								hidden : true
							}

							],
							caption : '사원 세부정보 등록',
							sortname : 'seq',
							multiselect : false,
							multiboxonly : false,
							viewrecords : false,
							height : 70,
							width : 1100,
							autowidth : false,
							shrinkToFit : false,
							cellEdit : true,
							rowNum : 100,
							scrollerbar : true,
							//rowList : [ 10, 20, 30 ],
							viewrecords : true,
							editurl : 'clientArray',
							cellsubmit : 'clientArray',
							autoencode : true,
							resizable : true,
							loadtext : '로딩중...',
							emptyrecords : '데이터가 없습니다.',
							cache : false,

							onCellSelect : function(rowid, iCol,
									previousCellValue, e) {

								if (iCol == 0) { // 사업장 cell 클릭

									showCodeDialog(this, rowid, iCol, "CO-02",
											"사업장 검색");

								} else if (iCol == 1) { // 부서 cell 클릭

									showCodeDialog(this, rowid, iCol, "CO-03",
											"부서 검색");

								} else if (iCol == 2) { // 직급 cell 클릭

									showCodeDialog(this, rowid, iCol, "HR-01",
											"직급 검색");

								} else if (iCol == 3 || iCol == 4) { // 사용자 ID 또는 비밀번호 cell 클릭

									checkUserIdDuplication(this, rowid, iCol);

								} else if (iCol == 7 || iCol == 8) { // 우편번호 또는 기본주소 cell 클릭

									showAddressDialog(this, rowid, iCol);

								}

							}
						}); // 사원 세부정보 그리드 끝

	}

	function initEvent() {

		$('#checkUserIdDuplicationButton').on("click",
						function() {

							checkUserIdDuplicationStatus = false;

							var newUserIdValue = $('#userIdInputBox').val()
									.trim();
							var duplicated;

							if (newUserIdValue == '') {

								alertError("사용자 에러", "검사할 ID 를 입력하세요");
								return;

							}

							// ajax 시작
							$
									.ajax({
										type : 'GET',
										url : '${pageContext.request.contextPath}/hr/emp/userid-duplication',
										data : {
											method : 'checkUserIdDuplication',
											companyCode : '${sessionScope.companyCode}',
											newUseId : newUserIdValue
										},
										dataType : 'json',
										cache : false,
										success : function(dataSet) {
											console.log(dataSet);

											duplicated = dataSet.result;

											if (duplicated == true) {

												alertError("ㅜㅜ", "중복된 ID 입니다");

												checkUserIdDuplicationStatus = false;

											} else if (duplicated == false) {

												alertError("^^",
														"사용 가능한 ID 입니다");

												checkUserIdDuplicationStatus = true;

											}

										}
									}); // ajax 끝			
						});

		$('#checkEmpCodeDuplicationButton')
				.on(
						"click",
						function() {

							checkEmpCodeDuplicationStatus = false;

							var newEmpCodeValue = $('#empCodeInputBox').val()
									.trim();
							var duplicated;

							if (newEmpCodeValue == '') {

								alertError("사용자 에러", "검사할 사원 코드를 입력하세요");
								return;

							}

							// ajax 시작
							$
									.ajax({
										type : 'GET',
										url : '${pageContext.request.contextPath}/hr/emp/code-duplication',
										data : {
											method : 'checkEmpCodeDuplication',
											companyCode : '${sessionScope.companyCode}',
											newEmpCode : newEmpCodeValue
										},
										dataType : 'json',
										cache : false,
										success : function(dataSet) {
											console.log(dataSet);

											duplicated = dataSet.result;

											if (duplicated == true) {

												alertError("ㅜㅜ", "중복된 사원 코드입니다");

												checkUserIdDuplicationStatus = false;

											} else if (duplicated == false) {

												alertError("^^",
														"사용 가능한 사원 코드입니다");

												checkEmpCodeDuplicationStatus = true;

											}

										}
									}); // ajax 끝		
						});

		$('#makeNewEmpCodeButton').on("click", function() {

			// ajax 시작
			$.ajax({
				type : 'GET',
				url : '${pageContext.request.contextPath}/hr/emp/newempcode',
				data : {
					method : 'getNewEmpCode',
					companyCode : '${sessionScope.companyCode}'
				},
				dataType : 'json',
				cache : false,
				success : function(dataSet) {
					console.log(dataSet);

					$('#empCodeInputBox').val(dataSet.newEmpCode);
					checkEmpCodeDuplicationStatus = true;

				}
			}); // ajax 끝	

		});

		$('#batchSaveButton')
				.on(
						"click",
						function() {

							var empBasicInfo = $('#empBasicInfoGrid')
									.getRowData(1);
							var empDetailInfo = $('#empDetailInfoGrid')
									.getRowData(1);

							for ( var key in empBasicInfo) {
								if (empBasicInfo[key] == ''
										|| empBasicInfo[key] == null) {

									alertError("사용자 에러",
											"사원 기본 정보 중에서 입력하지 않은 값이 있습니다")
									return;

								}
							}

							if (empDetailInfo.userId == ''
									|| empDetailInfo.userPassword == '') {

								alertError("사용자 에러",
										"사원 세부 정보 중에서 사용자 ID 와 비밀번호는 필수 입력 사항입니다")
								return;

							}

							confirmMsg = "새로운 사원 정보를 추가합니다 \r\n 계속하시겠습니까?";

							var confirmStatus = confirm(confirmMsg);

							if (confirmStatus == true) {

								// (1) 사원 기본정보부터 등록 시작
								resultList.push(empBasicInfo);

								alert(JSON.stringify(empBasicInfo));

								// ajax 시작
								$
										.ajax({
											type : 'POST',
											url : '${pageContext.request.contextPath}/hr/emp/batch',
											async : false,
											data : {
												method : 'batchListProcess',
												tableName : 'BASIC',
												batchList : JSON
														.stringify(resultList)
											},
											dataType : 'json',
											cache : false,
											success : function(dataSet) {

												console.log(dataSet);

											}
										}); // ajax 끝

								resultList = []; // 초기화

								// (2) 사원 사진 업로드, 사원세부정보 등록

								var imgUploadUrl;

								if ($('#uploadImgFile').val() != '') {

									var form = $('#imgFileUploadForm')[0];
									var formData = new FormData(form);

									$
											.ajax({
												method:"POST",
												url : '${pageContext.request.contextPath}/compinfo/imgfileupload?method=imgFileUpload',
												enctype : 'multipart/form-data',
												processData : false,
												contentType : false,
												data : formData,
												type : 'POST',
												async : false,
												success : function(dataSet) {

													imgUploadUrl = dataSet.ImgUrl;
												}
											});
								}

								empDetailInfo.image = imgUploadUrl;
								empDetailInfo.empCode = empBasicInfo.empCode;
								empDetailInfo.updateDate = empBasicInfo.hireDate;

								resultList.push(empDetailInfo);

								// ajax 시작
								$
										.ajax({
											type : 'POST',
											url : '${pageContext.request.contextPath}/hr/emp/batch',
											async : false,
											data : {
												method : 'batchListProcess',
												tableName : 'DETAIL',
												batchList : JSON
														.stringify(resultList)
											},
											dataType : 'json',
											cache : false,
											success : function(dataSet) {

												console.log(dataSet);

											}
										}); // ajax 끝

								resultList = []; // 초기화

								// (3) 사원 기밀정보 업로드

								var empSecretInfo = {
									companyCode : "${sessionScope.companyCode}",
									empCode : empBasicInfo.empCode,
									seq : 1,
									userPassword : empDetailInfo.userPassword,
									status : "INSERT"
								};

								resultList.push(empSecretInfo);

								// ajax 시작
								$
										.ajax({
											type : 'POST',
											url : '${pageContext.request.contextPath}/hr/emp/batch',
											async : false,
											data : {
												method : 'batchListProcess',
												tableName : 'SECRET',
												batchList : JSON
														.stringify(resultList)
											},
											dataType : 'json',
											cache : false,
											success : function(dataSet) {

												console.log(dataSet);

											}
										}); // ajax 끝

								resultList = []; // 초기화

								$('#empBasicInfoGrid').jqGrid('clearGridData');
								$('#empDetailInfoGrid').jqGrid('clearGridData');

							} else {

								alertError("^^", "취소되었습니다");

							}

							resultList = []; // 초기화		

						});

	}

	function showCodeDialog(grid, rowid, iCol, divisionCodeNo, title) {

		$("#codeDialog").dialog({
			title : '코드 검색',
			width : 425,
			height : 450,
			modal : true
		// 폼 외부 클릭 못하게
		});

		$.jgrid.gridUnload("#codeGrid");

		$("#codeGrid").jqGrid({
			method:"GET",
			url : "${pageContext.request.contextPath}/compinfo/codedetail2/list",
			datatype : "json",
			jsonReader : {
				root : "detailCodeList"
			},
			postData : {
				method : "findDetailCodeList",
				divisionCode : divisionCodeNo
			},
			colNames : [ '상세코드번호', '상세코드이름', '사용여부' ],
			colModel : [ {
				name : 'detailCode',
				width : 80,
				align : "center",
				editable : false
			}, {
				name : 'detailCodeName',
				width : 140,
				align : "center",
				editable : false
			}, {
				name : 'codeUseCheck',
				width : 80,
				align : "center",
				editable : false
			} ],
			width : 400,
			height : 300,
			caption : title,
			align : "center",
			viewrecords : true,
			rownumbers : true,
			onSelectRow : function(id) {

				var detailCode = $("#codeGrid").getCell(id, 1);
				var detailName = $("#codeGrid").getCell(id, 2);
				var codeUseCheck = $("#codeGrid").getCell(id, 3);

				if (codeUseCheck != 'n' && codeUseCheck != 'N') {

					if (grid != null) {

						$(grid).setCell(rowid, iCol, detailCode);

					} else {

						$('#searchDetailCodeName').val(detailName);
						$('#searchDetailCode').val(detailCode);

					}

					$("#codeDialog").dialog("close");

				} else {

					alertError("사용자 에러", "사용 가능한 코드가 아닙니다");

				}
			}
		});

	}

	function checkUserIdDuplication(grid, rowid, iCol) {

		$('#userIdInputBox').val("");

		$("#checkUserIdDialog")
				.dialog(
						{

							title : '사용자 ID 입력',
							autoOpen : true,
							width : 500,
							height : 200,
							modal : true, // 폼 외부 클릭 못하게

							buttons : { // 버튼 이벤트 적용
								"확인" : function() {

									if (checkUserIdDuplicationStatus == false) {

										alertError("사용자 에러",
												"중복된 ID 이거나 중복체크를 하지 않았습니다. </br> 값을 새로 입력해 주세요");

									} else if ($('#userPasswordInputBox').val() == '') {

										alertError("사용자 에러",
												"비밀번호를 입력하지 않았습니다. </br> 값을 새로 입력해 주세요");

									} else if (checkUserIdDuplicationStatus == true) {

										$(grid).setCell(
												rowid,
												3,
												$('#userIdInputBox').val()
														.trim());
										$(grid).setCell(
												rowid,
												4,
												$('#userPasswordInputBox')
														.val().trim());

										checkUserIdDuplicationStatus = false;
									}

									$("#checkUserIdDialog").dialog("close");

								},

								"취소" : function() {
									$("#checkUserIdDialog").dialog("close");
								}

							}
						});

	}

	function checkEmpCodeDuplication(grid, rowid, iCol) {

		$('#empCodeInputBox').val("");

		$("#checkEmpCodeDialog")
				.dialog(
						{

							title : '사원 코드 입력',
							autoOpen : true,
							width : 540,
							height : 190,
							modal : true, // 폼 외부 클릭 못하게

							buttons : { // 버튼 이벤트 적용
								"확인" : function() {

									if (checkEmpCodeDuplicationStatus == false) {

										alertError("사용자 에러",
												"중복된 사원코드이거나 중복체크를 하지 않았습니다. </br> 값을 새로 입력해 주세요");

									} else if (checkEmpCodeDuplicationStatus == true) {

										$(grid).setCell(
												rowid,
												iCol,
												$('#empCodeInputBox').val()
														.trim());
										checkEmpCodeDuplicationStatus = false;
									}

									$("#checkEmpCodeDialog").dialog("close");

								},

								"취소" : function() {
									$("#checkEmpCodeDialog").dialog("close");
								}

							}
						});

	}

	function showAddressDialog(grid, rowid, iCol) {

		$('#roadNameGuidanceMsg').show();
		$('#jibunGuidanceMsg').hide();

		$('#searchAddressValueInputBox').val(""); // 초기화
		$('#searchAddressMainNumberInputBox').val(""); // 초기화

		$('#searchAddressValueLabel').html('도로명/건물명');
		$('#searchAddressMainNumberLabel').html('(선택) 건물번호')

		// 주소 그리드 시작
		$("#addressGrid")
				.jqGrid(
						{

							mtype : 'POST',
							datatype : 'local',
							colNames : [ '', '우편번호', '주소', 'addressType',
									'addressNo' ],
							colModel : [
									{
										name : 'cnt',
										width : 20,
										align : "center",

										cellattr : function(rowid, val,
												rowObject, cm, rdata) {

											var result = "";

											if (chkcell.chkval != val) { //check 값이랑 비교값이 다른 경우
												var cellId = this.id + '_row_'
														+ rowid + '-' + cm.name;
												result = ' rowspan="1" id ="'
														+ cellId
														+ '" + name="cellRowspan"';
												chkcell = {
													cellId : cellId,
													chkval : val
												};
											} else {
												result = 'style="display:none" rowspanid="'
														+ chkcell.cellId + '"'; //같을 경우 display none 처리
											}
											return result;

										}
									}, {
										name : 'zipCode',
										width : 40,
										align : "center"
									}, {
										name : 'address',
										width : 200
									}, {
										name : 'addressType',
										width : 100,
										align : "center",
										hidden : true
									}, {
										name : 'addressNo',
										width : 100,
										align : "center",
										hidden : true
									},

							],
							width : 600,
							height : 280,
							rowNum : 100,
							align : "center",
							viewrecords : true,
							cache : false,
							loadonce : true,
							pager : '#addressGridPager',
							onSelectRow : function(id) {

								var zipCode = $("#addressGrid").getCell(id, 1);
								var address = $("#addressGrid").getCell(id, 2);

								$(grid).setCell(rowid, "zipCode", zipCode);
								$(grid).setCell(rowid, "basicAddress", address);

								$('#addressGrid').jqGrid('clearGridData');
								$("#addressDialog").dialog("close");

							},

							gridComplete : function() {
								/** 데이터 로딩시 함수 **/
								var grid = this;

								$('td[name="cellRowspan"]', grid)
										.each(
												function() {
													var spans = $(
															'td[rowspanid="'
																	+ this.id
																	+ '"]',
															grid).length + 1;
													if (spans > 1) {
														$(this).attr('rowspan',
																spans);
													}
												});

							}

						}); // 주소 그리드 끝

		// 주소 그리드 페이저 설정
		$('#addressGrid').navGrid("#addressGridPager", {
			add : false,
			del : false,
			edit : false,
			search : true,
			refresh : true,
			view : true
		});

		// 주소 dialog 설정 시작
		$("#addressDialog")
				.dialog(
						{
							title : '주소 검색',
							autoOpen : false,
							width : 630,
							height : 550,
							modal : true, // 폼 외부 클릭 못하게
							position : { // 폼 열릴 때 위치
								my : "center center",
								at : "center-80 center-120" // 폼 열릴 때, 대강 화면 중앙에 오도록
							},
							open : function(event, ui) {

								// 주소 dialog 내 요소들에 이벤트 등록

								$("#searchSidoNameBox")
										.selectmenu(
												{

													width : 140,

													change : function(event,
															data) {

														$(
																'#searchAddressValueInputBox')
																.val(""); // 초기화
														$(
																'#searchAddressMainNumberInputBox')
																.val(""); // 초기화

													}

												});

								$('#roadNameAddressRadio, #jibunAddressRadio')
										.on(
												"click",
												function() {

													var searchAddressType = $(
															':input:radio[name=searchAddressTypeCondition]:checked')
															.val();

													if (searchAddressType == 'roadNameAddress') {

														$(
																'#roadNameGuidanceMsg')
																.show();
														$('#jibunGuidanceMsg')
																.hide();

														$(
																'#searchAddressValueLabel')
																.html('도로명/건물명');
														$(
																'#searchAddressMainNumberLabel')
																.html(
																		'(선택) 건물번호')

													} else if (searchAddressType == 'jibunAddress') {

														$(
																'#roadNameGuidanceMsg')
																.hide();
														$('#jibunGuidanceMsg')
																.show();

														$(
																'#searchAddressValueLabel')
																.html('지번/건물명');
														$(
																'#searchAddressMainNumberLabel')
																.html(
																		'(선택) 지번본번')

													}

												});

								$('#addressSearchButton')
										.on(
												"click",
												function() {

													if ($(
															':input:radio[name=searchAddressTypeCondition]:checked')
															.val() == null) {

														alertError('사용자 에러',
																'주소 유형을 먼저 선택하세요');
														return;

													} else if ($(
															'#searchAddressValueInputBox')
															.val() == '') {

														alertError('사용자 에러',
																'검색할 주소를 먼저 입력하세요');
														return;

													}

													$
															.ajax({
																type : 'GET',
																url : '${pageContext.request.contextPath}/compinfo/address/list',
																data : {
																	method : 'searchAddressList',
																	sidoName : $(
																			"#searchSidoNameBox")
																			.val(), // 주소 검색시 시도 선택값
																	searchAddressType : $(
																			':input:radio[name=searchAddressTypeCondition]:checked')
																			.val(),
																	searchValue : $(
																			'#searchAddressValueInputBox')
																			.val(),
																	mainNumber : $(
																			'#searchAddressMainNumberInputBox')
																			.val()
																},
																dataType : 'json',
																cache : false,
																success : function(
																		dataSet) {

																	console
																			.log(dataSet);
																	var addressList = dataSet.addressList;

																	if (addressList.length == 0) {
																		alertError(
																				"ㅜㅜ",
																				"검색된 데이터가 없습니다");

																	} else {

																		$(
																				'#addressGrid')
																				.jqGrid(
																						'clearGridData'); // 초기화

																		chkcell = {
																			cellId : undefined,
																			chkval : undefined
																		}; // 초기화

																		// 주소 Data 넣기
																		$(
																				'#addressGrid')
																				.jqGrid(
																						'setGridParam',
																						{
																							datatype : 'local',
																							data : addressList
																						})
																				.trigger(
																						'reloadGrid');

																	}
																}
															});
												});
							}
						});

		$("#addressDialog").dialog("open");

	}
</script>
</head>
<body>

	<fieldset id="searchConditionFieldset"
		style="width: 10%; display: inline-block; vertical-align: top;">
		<legend>사원 등록</legend>
		<input type="button" value="새로운 사원 정보 저장" id="batchSaveButton" />

	</fieldset>

	<fieldset id="addNewEmpPhotoFieldset"
		style="width: 20%; height: 60px; display: inline-block; vertical-align: top;">
		<legend>사진 등록</legend>

		<form name='imgFileUploadForm' id='imgFileUploadForm' method='POST'
			enctype='multipart/form-data'>
			<input type='file' name='uploadImgFile' id='uploadImgFile'>
		</form>



	</fieldset>


	<table id="empBasicInfoGrid"></table>
	<div id="empBasicInfoGridPager"></div>

	<table id="empDetailInfoGrid"></table>
	<div id="empDetailInfoGridPager"></div>

	<div id="codeDialog">
		<table id="codeGrid"></table>
	</div>

	<div id="checkUserIdDialog">
		<table>
			<tr>
				<td><label for="userIdInputBox"
					style="font-size: 20px; margin-right: 10px">새로운 사용자 ID</label></td>
				<td><input type="text" id="userIdInputBox" />&nbsp;&nbsp; <input
					type="button" value="ID 중복 체크" id="checkUserIdDuplicationButton"
					style="font-size: 16px;" /></td>
			</tr>
			<tr>
				<td><label for="userPasswordInputBox"
					style="font-size: 20px; margin-right: 10px">비밀번호</label></td>
				<td><input type="text" id="userPasswordInputBox" />&nbsp;&nbsp;
				</td>
			</tr>
		</table>

	</div>

	<div id="checkEmpCodeDialog">
		<table>
			<tr>
				<td><label for="empCodeInputBox"
					style="font-size: 20px; margin-right: 10px">새로운 사원코드</label> <input
					type="text" id="empCodeInputBox" />&nbsp;&nbsp;</td>
				<td><input type="button" value="사원 코드 중복 체크"
					id="checkEmpCodeDuplicationButton" style="font-size: 16px;" /></td>
			</tr>
			<tr>
				<td></td>
				<td><input type="button" value="사원 코드 자동 생성"
					id="makeNewEmpCodeButton" style="font-size: 16px;" /></td>
			</tr>

		</table>

	</div>

	<div id="addressDialog">
		<fieldset id="searchSidoNameFieldset" style="display: inline;">
			<legend>시도</legend>

			<select id="searchSidoNameBox">
				<option value="시도 선택">시도 선택</option>
				<option value="서울특별시">서울특별시</option>
				<option value="부산광역시">부산광역시</option>
				<option value="대구광역시">대구광역시</option>
				<option value="인천광역시">인천광역시</option>
				<option value="광주광역시">광주광역시</option>
				<option value="대전광역시">대전광역시</option>
				<option value="울산광역시">울산광역시</option>
				<option value="세종특별자치시">세종특별자치시</option>
				<option value="경기도">경기도</option>
				<option value="강원도">강원도</option>
				<option value="충청북도">충청북도</option>
				<option value="충청남도">충청남도</option>
				<option value="전라북도">전라북도</option>
				<option value="전라남도">전라남도</option>
				<option value="경상북도">경상북도</option>
				<option value="경상남도">경상남도</option>
				<option value="제주특별자치도">제주특별자치도</option>

			</select>
		</fieldset>

		<fieldset id="searchAddressTypeFieldset" style="display: inline;">
			<legend>주소 유형</legend>

			<label for="roadNameAddressRadio">도로명 주소</label> <input type="radio"
				name="searchAddressTypeCondition" value="roadNameAddress"
				id="roadNameAddressRadio"> <label for="jibunAddressRadio">지번
				주소</label> <input type="radio" name="searchAddressTypeCondition"
				value="jibunAddress" id="jibunAddressRadio">

		</fieldset>
		&nbsp; <input type="button" value="주소 조회" id="addressSearchButton"
			style="font-size: 20px" />

		<div class="guidanceMsg" id="roadNameGuidanceMsg">도로명 또는 건물명을
			입력하세요. &nbsp;예) 중앙로, 불정로432번길, 혜람빌딩</div>
		<div class="guidanceMsg" id="jibunGuidanceMsg">동/읍/면/리 이름 또는
			건물명을 입력하세요. &nbsp;예) 역삼동, 화도읍, 둔내면, 혜람빌딩</div>

		<label for="searchAddressValueInput" id="searchAddressValueLabel"
			class="searchAddressLabel"></label> &nbsp; <input type="text"
			id="searchAddressValueInputBox" /> &nbsp; &nbsp; <label
			for="searchAddressMainNumberInputBox"
			id="searchAddressMainNumberLabel" class="searchAddressLabel"></label>
		&nbsp; <input type="text" id="searchAddressMainNumberInputBox" />
		&nbsp;

		<table id="addressGrid"></table>
		<div id="addressGridPager"></div>

	</div>
	<!-- addressDialog 끝 -->


</body>
</html>