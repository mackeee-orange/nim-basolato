/* Generated by the Nim Compiler v1.4.4 */
var framePtr = null;
var excHandler = 0;
var lastJSError = null;
function toJSStr(s_11770096) {
                    var Tmp5;
            var Tmp7;

  var result_11770097 = null;

    var res_11770170 = newSeq_11770128((s_11770096).length);
    var i_11770172 = 0;
    var j_11770174 = 0;
    L1: do {
        L2: while (true) {
        if (!(i_11770172 < (s_11770096).length)) break L2;
          var c_11770175 = s_11770096[i_11770172];
          if ((c_11770175 < 128)) {
          res_11770170[j_11770174] = String.fromCharCode(c_11770175);
          i_11770172 += 1;
          }
          else {
            var helper_11770198 = newSeq_11770128(0);
            L3: do {
                L4: while (true) {
                if (!true) break L4;
                  var code_11770199 = c_11770175.toString(16);
                  if ((((code_11770199) == null ? 0 : (code_11770199).length) == 1)) {
                  helper_11770198.push("%0");;
                  }
                  else {
                  helper_11770198.push("%");;
                  }
                  
                  helper_11770198.push(code_11770199);;
                  i_11770172 += 1;
                    if (((s_11770096).length <= i_11770172)) Tmp5 = true; else {                      Tmp5 = (s_11770096[i_11770172] < 128);                    }                  if (Tmp5) {
                  break L3;
                  }
                  
                  c_11770175 = s_11770096[i_11770172];
                }
            } while(false);
++excHandler;
            Tmp7 = framePtr;
            try {
            res_11770170[j_11770174] = decodeURIComponent(helper_11770198.join(""));
--excHandler;
} catch (EXC) {
 var prevJSError = lastJSError;
 lastJSError = EXC;
 --excHandler;
            framePtr = Tmp7;
            res_11770170[j_11770174] = helper_11770198.join("");
            lastJSError = prevJSError;
            } finally {
            framePtr = Tmp7;
            }
          }
          
          j_11770174 += 1;
        }
    } while(false);
    if (res_11770170.length < j_11770174) { for (var i=res_11770170.length;i<j_11770174;++i) res_11770170.push(null); }
               else { res_11770170.length = j_11770174; };
    result_11770097 = res_11770170.join("");

  return result_11770097;

}
function rawEcho() {
          var buf = "";
      for (var i = 0; i < arguments.length; ++i) {
        buf += toJSStr(arguments[i]);
      }
      console.log(buf);
    

  
}
function cstrToNimstr(c_11770079) {
      var ln = c_11770079.length;
  var result = new Array(ln);
  var r = 0;
  for (var i = 0; i < ln; ++i) {
    var ch = c_11770079.charCodeAt(i);

    if (ch < 128) {
      result[r] = ch;
    }
    else {
      if (ch < 2048) {
        result[r] = (ch >> 6) | 192;
      }
      else {
        if (ch < 55296 || ch >= 57344) {
          result[r] = (ch >> 12) | 224;
        }
        else {
            ++i;
            ch = 65536 + (((ch & 1023) << 10) | (c_11770079.charCodeAt(i) & 1023));
            result[r] = (ch >> 18) | 240;
            ++r;
            result[r] = ((ch >> 12) & 63) | 128;
        }
        ++r;
        result[r] = ((ch >> 6) & 63) | 128;
      }
      ++r;
      result[r] = (ch & 63) | 128;
    }
    ++r;
  }
  return result;
  

  
}
if (!Math.trunc) {
  Math.trunc = function(v) {
    v = +v;
    if (!isFinite(v)) return v;
    return (v - v % 1) || (v < 0 ? -0 : v === 0 ? v : 0);
  };
}

function newSeq_11770128(len_11770131) {
  var result_11770133 = [];

  var F={procname:"newSeq.newSeq",prev:framePtr,filename:"/nim/lib/system.nim",line:0};
  framePtr = F;
    F.line = 656;
    result_11770133 = new Array(len_11770131); for (var i=0;i<len_11770131;++i) {result_11770133[i]=null;}  framePtr = F.prev;

  return result_11770133;

}
function print(str_12167004) {
  var F={procname:"js_output.print",prev:framePtr,filename:"/root/project/examples/example/app/http/views/scripts/js_output.nim",line:0};
  framePtr = F;
    F.line = 2;
    rawEcho(cstrToNimstr(str_12167004));
  framePtr = F.prev;

  
}
var F={procname:"module js_output",prev:framePtr,filename:"/root/project/examples/example/app/http/views/scripts/js_output.nim",line:0};
framePtr = F;
framePtr = F.prev;
var F={procname:"module js_output",prev:framePtr,filename:"/root/project/examples/example/app/http/views/scripts/js_output.nim",line:0};
framePtr = F;
framePtr = F.prev;
