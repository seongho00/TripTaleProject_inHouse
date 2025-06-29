<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="ARTICLE MODIFY" />
<%@ include file="../common/head.jspf"%>
<%@ include file="../common/daisyUi.jspf"%>

<style>
/* 토스트 UI */
.absolute {
	position: absolute;
}

.relative {
	position: relative;
}

.top-0 {
	top: 0;
}

.left-0 {
	left: 0;
}

.w-full {
	width: 100%;
}

.ratio-16\/9::after {
	content: "";
	display: block;
	padding-top: calc(100%/ 16 * 9);
}

.ratio-16\/9::after {
	content: "";
	display: block;
	padding-top: calc(100%/ 16 * 9);
}

.ratio-9\/16::after {
	content: "";
	display: block;
	padding-top: calc(100%/ 9 * 16);
}

.ratio-1\/1::after {
	content: "";
	display: block;
	padding-top: calc(100%/ 1 * 1);
}

.ratio-1\/2::after {
	content: "";
	display: block;
	padding-top: calc(100%/ 1 * 2);
}
/* 토스트 UI */

/* 에디터 본문 내용 텍스트 크기 조정 */
.toastui-editor-contents {
	font-size: 20px; /* 원하는 크기로 조절 */
}
/* 헤딩(h1~h6) 크기 비율 조정 */

/* 본문 텍스트 크기 및 줄간격 조정 */
.toastui-editor-contents {
	font-size: 20px !important; /* 본문 글씨 크기 */
	line-height: 1.8 !important; /* 줄 간격 추가로 가독성 향상 */
	word-break: break-word !important; /* 긴 단어 줄바꿈 */
}

/* 헤딩(h1~h6) 크기 설정 */
.toastui-editor-contents h1 {
	font-size: 2.25rem !important; /* 36px */
	line-height: 1.3 !important;
	margin: 1.2em 0 0.6em;
}

.toastui-editor-contents h2 {
	font-size: 1.875rem !important; /* 30px */
	line-height: 1.3 !important;
	margin: 1.1em 0 0.5em;
}

.toastui-editor-contents h3 {
	font-size: 1.5rem !important; /* 24px */
	line-height: 1.4 !important;
}

.toastui-editor-contents h4 {
	font-size: 1.25rem !important; /* 20px */
	line-height: 1.3 !important;
}

.toastui-editor-contents h5 {
	font-size: 1.125rem !important; /* 18px */
	line-height: 1.3 !important;
}

.toastui-editor-contents h6 {
	font-size: 1rem !important; /* 16px */
	line-height: 1.3 !important;
}

/* 마크다운 프리뷰 강조 배경 제거 */
.toastui-editor-md-preview-highlight {
	background-color: transparent !important;
}
</style>

<script>

// const options = {
// 		  // ...
// 		  // 직접 입력하면서 커스터마이징 가능
// 		  // toolbarItems 뻬면 기본적인 툴바 다 사용하는 것
// 		  toolbarItems: [
// 		    ['heading', 'bold', 'italic', 'strike'],
// 		    ['hr', 'quote'],
// 		    ['ul', 'ol', 'task', 'indent', 'outdent'],
// 		    ['table', 'image', 'link'],
// 		    ['code', 'codeblock'],
// 		    ['scrollSync'],
// 		  ],
// 		};

function getUriParams(uri) {
	  uri = uri.trim();
	  uri = uri.replaceAll("&amp;", "&");
	  if (uri.indexOf("#") !== -1) {
	    let pos = uri.indexOf("#");
	    uri = uri.substr(0, pos);
	  }

	  let params = {};

	  uri.replace(/[?&]+([^=&]+)=([^&]*)/gi, function (str, key, value) {
	    params[key] = value;
	  });
	  return params;
	}

	function codepenPlugin() {
	  const toHTMLRenderers = {
	    codepen(node) {
	      const html = renderCodepen(node.literal);

	      return [
	        { type: "openTag", tagName: "div", outerNewLine: true },
	        { type: "html", content: html },
	        { type: "closeTag", tagName: "div", outerNewLine: true }
	      ];
	    }
	  };

	  function renderCodepen(uri) {
	    let uriParams = getUriParams(uri);

	    let height = 400;

	    let preview = "";

	    if (uriParams.height) {
	      height = uriParams.height;
	    }

	    let width = "100%";

	    if (uriParams.width) {
	      width = uriParams.width;
	    }

	    if (!isNaN(width)) {
	      width += "px";
	    }

	    let iframeUri = uri;

	    if (iframeUri.indexOf("#") !== -1) {
	      let pos = iframeUri.indexOf("#");
	      iframeUri = iframeUri.substr(0, pos);
	    }

	    return (
	      '<iframe height="' +
	      height +
	      '" style="width: ' +
	      width +
	      ';" scrolling="no" title="" src="' +
	      iframeUri +
	      '" frameborder="no" allowtransparency="true" allowfullscreen="true"></iframe>'
	    );
	  }

	  return { toHTMLRenderers };
	}
	// 유튜브 플러그인 끝

	// repl 플러그인 시작
	function replPlugin() {
	  const toHTMLRenderers = {
	    repl(node) {
	      const html = renderRepl(node.literal);

	      return [
	        { type: "openTag", tagName: "div", outerNewLine: true },
	        { type: "html", content: html },
	        { type: "closeTag", tagName: "div", outerNewLine: true }
	      ];
	    }
	  };

	  function renderRepl(uri) {
	    var uriParams = getUriParams(uri);

	    var height = 400;

	    if (uriParams.height) {
	      height = uriParams.height;
	    }

	    return (
	      '<iframe frameborder="0" width="100%" height="' +
	      height +
	      'px" src="' +
	      uri +
	      '"></iframe>'
	    );
	  }

	  return { toHTMLRenderers };
	}

	function youtubePlugin() {
	  const toHTMLRenderers = {
	    youtube(node) {
	      const html = renderYoutube(node.literal);

	      return [
	        { type: "openTag", tagName: "div", outerNewLine: true },
	        { type: "html", content: html },
	        { type: "closeTag", tagName: "div", outerNewLine: true }
	      ];
	    }
	  };

	  function renderYoutube(uri) {
	    uri = uri.replace("https://www.youtube.com/watch?v=", "");
	    uri = uri.replace("http://www.youtube.com/watch?v=", "");
	    uri = uri.replace("www.youtube.com/watch?v=", "");
	    uri = uri.replace("youtube.com/watch?v=", "");
	    uri = uri.replace("https://youtu.be/", "");
	    uri = uri.replace("http://youtu.be/", "");
	    uri = uri.replace("youtu.be/", "");

	    let uriParams = getUriParams(uri);

	    let width = "100%";
	    let height = "100%";

	    let maxWidth = 500;

	    if (!uriParams["max-width"] && uriParams["ratio"] == "9/16") {
	      uriParams["max-width"] = 300;
	    }

	    if (uriParams["max-width"]) {
	      maxWidth = uriParams["max-width"];
	    }

	    let ratio = "16/9";

	    if (uriParams["ratio"]) {
	      ratio = uriParams["ratio"];
	    }

	    let marginLeft = "auto";

	    if (uriParams["margin-left"]) {
	      marginLeft = uriParams["margin-left"];
	    }

	    let marginRight = "auto";

	    if (uriParams["margin-right"]) {
	      marginRight = uriParams["margin-right"];
	    }

	    let youtubeId = uri;

	    if (youtubeId.indexOf("?") !== -1) {
	      let pos = uri.indexOf("?");
	      youtubeId = youtubeId.substr(0, pos);
	    }

	    return (
	      '<div style="max-width:' +
	      maxWidth +
	      "px; margin-left:" +
	      marginLeft +
	      "; margin-right:" +
	      marginRight +
	      ';" class="ratio-' +
	      ratio +
	      ' relative"><iframe class="absolute top-0 left-0 w-full" width="' +
	      width +
	      '" height="' +
	      height +
	      '" src="https://www.youtube.com/embed/' +
	      youtubeId +
	      '" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>'
	    );
	  }
	  // 유튜브 플러그인 끝

	  return { toHTMLRenderers };
	}

	// katex 플러그인
	function katexPlugin() {
	  const toHTMLRenderers = {
	    katex(node) {
	      let html = katex.renderToString(node.literal, {
	        throwOnError: false
	      });

	      return [
	        { type: "openTag", tagName: "div", outerNewLine: true },
	        { type: "html", content: html },
	        { type: "closeTag", tagName: "div", outerNewLine: true }
	      ];
	    }
	  };

	  return { toHTMLRenderers };
	}

	const ToastEditor__chartOptions = {
	  minWidth: 100,
	  maxWidth: 600,
	  minHeight: 100,
	  maxHeight: 300
	};
	
	let editorInstance = null;

	function ToastEditor__init() {
		  $(".toast-ui-editor").each(function (index, node) {
		    const $node = $(node);
		    const $initialValueEl = $node.find(" > script");
		    const initialValue =
		      $initialValueEl.length == 0 ? "" : $initialValueEl.html().trim();

		    const editor = new toastui.Editor({
		      el: node,
		      previewStyle: "vertical",
		      previewHighlight: false,
		      initialValue: initialValue,
		      height: "600px",
		      plugins: [
		        [toastui.Editor.plugin.chart, ToastEditor__chartOptions],
		        [toastui.Editor.plugin.codeSyntaxHighlight, { highlighter: Prism }],
		        toastui.Editor.plugin.colorSyntax,
		        toastui.Editor.plugin.tableMergedCell,
		        toastui.Editor.plugin.uml,
		        katexPlugin,
		        youtubePlugin,
		        codepenPlugin,
		        replPlugin
		      ],
		      customHTMLSanitizer: (html) => {
		        return (
		          DOMPurify.sanitize(html, {
		            ADD_TAGS: ["iframe"],
		            ADD_ATTR: [
		              "width",
		              "height",
		              "allow",
		              "allowfullscreen",
		              "frameborder",
		              "scrolling",
		              "style",
		              "title",
		              "loading",
		              "allowtransparency"
		            ]
		          }) || ""
		        );
		      },
		      // ✅ 이미지 업로드 hook 추가
		      hooks: {
		        addImageBlobHook: async (blob, callback) => {
		          try {
		            const formData = new FormData();
		            formData.append("file", blob);

		            const response = await fetch('/usr/article/fileUpload', {
		              method: 'POST',
		              body: formData
		            });

		            const result = await response.json();
		            if (result.url) {
		              callback(result.url, '업로드된 이미지');
		            } else {
		              alert('이미지 업로드 실패');
		            }
		          } catch (e) {
		            alert('이미지 업로드 중 오류 발생');
		            console.error(e);
		          }
		        }
		      }
		    });
		    
		    editorInstance = editor;


		    // ✅ 텍스트 크기 강제 적용 (Markdown/위지윅 모두 대응)
		    setTimeout(() => {
		      const mdEditor = node.querySelector('.CodeMirror pre');
		      const wwEditor = node.querySelector('[contenteditable="true"]');
		      if (mdEditor) mdEditor.style.fontSize = "20px";
		      if (wwEditor) wwEditor.style.fontSize = "20px";
		    }, 100);

		    $node.data("data-toast-editor", editor);
		  });
		}



	function ToastEditorView__init() {
	  $(".toast-ui-viewer").each(function (index, node) {
	    const $node = $(node);
	    const $initialValueEl = $node.find(" > script");
	    const initialValue =
	      $initialValueEl.length == 0 ? "" : $initialValueEl.html().trim();
	    $node.empty();

	    let viewer = new toastui.Editor.factory({
	      el: node,
	      initialValue: initialValue,
	      viewer: true,
	      plugins: [
	        [toastui.Editor.plugin.codeSyntaxHighlight, { highlighter: Prism }],
	        toastui.Editor.plugin.colorSyntax,
	        toastui.Editor.plugin.tableMergedCell,
	        toastui.Editor.plugin.uml,
	        katexPlugin,
	        youtubePlugin,
	        codepenPlugin,
	        replPlugin
	      ],
	      customHTMLSanitizer: (html) => {
	        return (
	          DOMPurify.sanitize(html, {
	            ADD_TAGS: ["iframe"],
	            ADD_ATTR: [
	              "width",
	              "height",
	              "allow",
	              "allowfullscreen",
	              "frameborder",
	              "scrolling",
	              "style",
	              "title",
	              "loading",
	              "allowtransparency"
	            ]
	          }) || ""
	        );
	      }
	    });

	    $node.data("data-toast-editor", viewer);
	  });
	}

	$(function () {
	  ToastEditor__init();
	  ToastEditorView__init();
	});
	
	
	$(document).ready(function () {
		$('#articleForm').on('submit', function () {
			  const markdown = editorInstance.getMarkdown(); // 또는 .getHTML()
			  $('#articleContent').val(markdown);
		});
	});


	// 이미지 넣기
 $(document).ready(function () {
  const $fileList = $('#fileList');
  const $inputLabel = $('.btn-info');

  $('#imageInput').on('change', function (e) {
    const files = e.target.files;
    if (!files || files.length === 0) return;

    for (let i = 0; i < files.length; i++) {
      const file = files[i];
      if (!file.type.startsWith('image/')) continue;

      const $fileItem = $(`
        <div class="imageItem flex justify-start items-center pl-2 w-full">
          <i class="fa-solid fa-xmark pr-1 cursor-pointer"></i>
          <div class="text-base text-gray-700 flex justify-start items-center">\${file.name}</div>
        </div>
      `);

      const $newInput = $('<input type="file" name="images" accept="image/*" class="hidden" />');
      $newInput[0].files = createFileList(file); // Set single file as input

      $fileItem.find('.fa-xmark').on('click', function () {
        $fileItem.remove();
        $newInput.remove();
      });

      $fileList.append($fileItem);
      $inputLabel.after($newInput); // append to form
    }

    // input 초기화
    $(this).val('');
  });

  // input.files는 읽기 전용이라 FileList를 만들기 위한 헬퍼
  function createFileList(file) {
    const dataTransfer = new DataTransfer();
    dataTransfer.items.add(file);
    return dataTransfer.files;
  }
});
</script>
<div class="flex flex-col m-10 h-[90vh]">
	<form id="articleForm" method="POST" action="/usr/article/doModify"
		enctype="multipart/form-data">
		<input type="hidden" name="articleId" value="${param.articleId }"
			onsubmit="return confirm('저장하시겠습니까?');" />

		<!-- 제목 입력 -->
		<div class="mb-4">

			<input type="text" id="articleTitle" name="title"
				class="text-lg w-1/2 h-14 px-4 py-2 border border-gray-300 rounded focus:outline-none focus:border-blue-400"
				placeholder="제목을 입력하세요" value="${article.title}">
		</div>
		<div class="flex justify-start items-center ">

			<div id="fileList"
				class="border rounded bg-gray-100 w-[500px] h-[100px] overflow-auto">
				<c:forEach var="articleImage" items="${articleImages }">
					<div class="imageItem flex justify-start items-center pl-2 w-full">
						<i class="fa-solid fa-xmark pr-1 cursor-pointer"></i>
						<div
							class="text-base text-gray-700 flex justify-start items-center">${articleImage.fileName}</div>

					</div>
				</c:forEach>
			</div>
			<label class="btn btn-sm btn-info ">
				파일 선택
				<input type="file" id="imageInput" name="images" multiple
					accept="image/*" class="hidden" />
			</label>

		</div>

		<textarea name="body" id="articleContent" class="hidden"></textarea>
		<button
			class="btn btn-primary fixed bottom-6 right-6 z-50 px-6 py-3 rounded-full shadow-lg">저장하기</button>
	</form>
	<div class="toast-ui-editor flex-grow ">
		<script type="text/x-template">
${article.body}
  </script>
	</div>
</div>



<%@ include file="../common/foot.jspf"%>