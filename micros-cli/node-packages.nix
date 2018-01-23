{nodeEnv, fetchurl, fetchgitPrivate, globalBuildInputs ? [], srcOnly}:

let
  sources = {
    "@atlassian/inject-environment-into-object-1.1.1" = {
      name = "_at_atlassian_slash_inject-environment-into-object";
      packageName = "@atlassian/inject-environment-into-object";
      version = "1.1.1";
      src = fetchgitPrivate {
        url = "ssh://git@bitbucket.org/atlassianlabs/inject-environment-into-object.git";
        rev = "aa4a98adb641e3ff8d4812a2787ac07c7d933fa9";
        sha256 = "10ic2y5gdp4a4i9ibszwcila4sna39h8jqqgj349dyw6i3692bsn";
      };
    };
    "netrc-0.1.4" = {
      name = "netrc";
      packageName = "netrc";
      version = "0.1.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/netrc/-/netrc-0.1.4.tgz";
        sha1 = "6be94fcaca8d77ade0a9670dc460914c94472444";
      };
    };
    "@atlassian/ws-4.1.0" = {
      name = "_at_atlassian_slash_ws";
      packageName = "@atlassian/ws";
      version = "4.1.0";
      src = fetchgitPrivate {
        url = "ssh://git@stash.atlassian.com:7997/micros/ws.git";
        rev = "afeea1399fcec2b543e27c24e2d9335d78551386";
        sha256 = "1brai7nva39n49c4fi7vg4x85i1p2c7xl6g2b1g3bd1mjfk0jv9c";
      };
    };
    "alamo-0.1.4" = {
      name = "alamo";
      packageName = "alamo";
      version = "0.1.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/alamo/-/alamo-0.1.4.tgz";
        sha1 = "bee0efd299e7c5335bb0c8af012bc16edc087e77";
      };
    };
    "async-2.6.0" = {
      name = "async";
      packageName = "async";
      version = "2.6.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/async/-/async-2.6.0.tgz";
        sha512 = "0zp4b5788400npi1ixjry5x3a4m21c8pnknk8v731rgnwnjbp5ijmfcf5ppmn1ap4a04md1s9dr8n9ygdvrmiai590v0k6dby1wc1y4";
      };
    };
    "awscred-1.2.0" = {
      name = "awscred";
      packageName = "awscred";
      version = "1.2.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/awscred/-/awscred-1.2.0.tgz";
        sha1 = "9ba714a0d2feb625b848f15c62746c07aebdc3b5";
      };
    };
    "bluebird-3.5.1" = {
      name = "bluebird";
      packageName = "bluebird";
      version = "3.5.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/bluebird/-/bluebird-3.5.1.tgz";
        sha512 = "2631bhp784qng0ifbypsmvijn6kjfvkhq2335kdz8ix5qi3wb3lbpg94xjn1av2s6i95ygr5a4y9j1721dw6zdbywwh1m48by4qpa1h";
      };
    };
    "chalk-1.1.3" = {
      name = "chalk";
      packageName = "chalk";
      version = "1.1.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/chalk/-/chalk-1.1.3.tgz";
        sha1 = "a8115c55e4a702fe4d150abd3872822a7e09fc98";
      };
    };
    "ci-info-1.1.2" = {
      name = "ci-info";
      packageName = "ci-info";
      version = "1.1.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/ci-info/-/ci-info-1.1.2.tgz";
        sha512 = "1jbmihk48iby72h0b6k4rvhrnaydml49qyjcb83ix310ivjzd4zmdk3yxx1ssn6ryjblm7xzaswnwj53rxwcyn1fr0jm7bzvhy8hcdr";
      };
    };
    "cli-spinner-0.2.7" = {
      name = "cli-spinner";
      packageName = "cli-spinner";
      version = "0.2.7";
      src = fetchurl {
        url = "https://registry.npmjs.org/cli-spinner/-/cli-spinner-0.2.7.tgz";
        sha1 = "7f7868a6f52ed5a621d5169ced428b61847a97c7";
      };
    };
    "clone-2.1.1" = {
      name = "clone";
      packageName = "clone";
      version = "2.1.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/clone/-/clone-2.1.1.tgz";
        sha1 = "d217d1e961118e3ac9a4b8bba3285553bf647cdb";
      };
    };
    "cloudfront-0.4.1" = {
      name = "cloudfront";
      packageName = "cloudfront";
      version = "0.4.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/cloudfront/-/cloudfront-0.4.1.tgz";
        sha1 = "6e21502126977564772b3bbef5b059f1e8499c41";
      };
    };
    "colors-1.1.2" = {
      name = "colors";
      packageName = "colors";
      version = "1.1.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/colors/-/colors-1.1.2.tgz";
        sha1 = "168a4701756b6a7f51a12ce0c97bfa28c084ed63";
      };
    };
    "debug-2.6.9" = {
      name = "debug";
      packageName = "debug";
      version = "2.6.9";
      src = fetchurl {
        url = "https://registry.npmjs.org/debug/-/debug-2.6.9.tgz";
        sha512 = "0q0fsr8bk1m83z0am0h2xn09vyfcf18adscxms8hclznwks1aihsisd96h8npx0idq5wwnypnqrkyk25m5d9zh3dk7rjs29nybc8bkc";
      };
    };
    "event-stream-3.3.4" = {
      name = "event-stream";
      packageName = "event-stream";
      version = "3.3.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/event-stream/-/event-stream-3.3.4.tgz";
        sha1 = "4ab4c9a0f5a54db9338b4c34d86bfce8f4b35571";
      };
    };
    "js-yaml-3.10.0" = {
      name = "js-yaml";
      packageName = "js-yaml";
      version = "3.10.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/js-yaml/-/js-yaml-3.10.0.tgz";
        sha512 = "0h26sq1bwxc45bm0hvlcadrbk4bizzaw729wvw690ya7mpys45bqfzdqwhjkdrnq0i44dzxckykz4bix22jfdyfg1asybg3yzczjsrv";
      };
    };
    "mime-1.6.0" = {
      name = "mime";
      packageName = "mime";
      version = "1.6.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/mime/-/mime-1.6.0.tgz";
        sha512 = "1x901mk5cdib4xp27v4ivwwr7mhy64r4rk953bzivi5p9lf2bhw88ra2rhkd254xkdx2d3q30zkq239vc4yx4pfsj4hpys8rbr6fif7";
      };
    };
    "mime-types-2.1.17" = {
      name = "mime-types";
      packageName = "mime-types";
      version = "2.1.17";
      src = fetchurl {
        url = "https://registry.npmjs.org/mime-types/-/mime-types-2.1.17.tgz";
        sha1 = "09d7a393f03e995a79f8af857b70a9e0ab16557a";
      };
    };
    "moment-2.19.2" = {
      name = "moment";
      packageName = "moment";
      version = "2.19.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/moment/-/moment-2.19.2.tgz";
        sha512 = "2s41fkwslr6lp0v2yz37fmsbfiy98x8s1fjc6smx82sf8r6fiq9wyx61javlkn8agzn51zcanhfyxj4wvsc8wyrz5yilzy4ff4a7zj5";
      };
    };
    "npm-5.6.0" = {
      name = "npm";
      packageName = "npm";
      version = "5.6.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/npm/-/npm-5.6.0.tgz";
        sha512 = "0nnr796ik5h8bsd3k9ygivivr3na2ksnf5iipf8dsnn20j10i9sgmhmsnzbimd2pqgjbrpp8gbpl2q7j5c7yjqjfirrh8xcc3v3gpws";
      };
    };
    "priorityqueuejs-1.0.0" = {
      name = "priorityqueuejs";
      packageName = "priorityqueuejs";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/priorityqueuejs/-/priorityqueuejs-1.0.0.tgz";
        sha1 = "2ee4f23c2560913e08c07ce5ccdd6de3df2c5af8";
      };
    };
    "promptly-2.2.0" = {
      name = "promptly";
      packageName = "promptly";
      version = "2.2.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/promptly/-/promptly-2.2.0.tgz";
        sha1 = "2a13fa063688a2a5983b161fff0108a07d26fc74";
      };
    };
    "readdirp-2.1.0" = {
      name = "readdirp";
      packageName = "readdirp";
      version = "2.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/readdirp/-/readdirp-2.1.0.tgz";
        sha1 = "4ed0ad060df3073300c48440373f72d1cc642d78";
      };
    };
    "request-2.83.0" = {
      name = "request";
      packageName = "request";
      version = "2.83.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/request/-/request-2.83.0.tgz";
        sha512 = "0by1djkn836sqd9pk2c777wcjvp34qbk1plx7s4lmykljrblpjc64dvn6ni2vyxsbyk33wnl6avym8vgw0ggr4226xakck8mw7y07cm";
      };
    };
    "shell-quote-1.6.1" = {
      name = "shell-quote";
      packageName = "shell-quote";
      version = "1.6.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/shell-quote/-/shell-quote-1.6.1.tgz";
        sha1 = "f4781949cce402697127430ea3b3c5476f481767";
      };
    };
    "shortid-2.2.8" = {
      name = "shortid";
      packageName = "shortid";
      version = "2.2.8";
      src = fetchurl {
        url = "https://registry.npmjs.org/shortid/-/shortid-2.2.8.tgz";
        sha1 = "033b117d6a2e975804f6f0969dbe7d3d0b355131";
      };
    };
    "stream-ext-0.0.1" = {
      name = "stream-ext";
      packageName = "stream-ext";
      version = "0.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/stream-ext/-/stream-ext-0.0.1.tgz";
        sha1 = "8b19001f9f862d14b7f3e28f3b7f9e649dd43b24";
      };
    };
    "underscore-1.8.3" = {
      name = "underscore";
      packageName = "underscore";
      version = "1.8.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/underscore/-/underscore-1.8.3.tgz";
        sha1 = "4f3fb53b106e6097fcf9cb4109f2a5e9bdfa5022";
      };
    };
    "validator-6.3.0" = {
      name = "validator";
      packageName = "validator";
      version = "6.3.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/validator/-/validator-6.3.0.tgz";
        sha1 = "47ce23ed8d4eaddfa9d4b8ef0071b6cf1078d7c8";
      };
    };
    "clone-1.0.3" = {
      name = "clone";
      packageName = "clone";
      version = "1.0.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/clone/-/clone-1.0.3.tgz";
        sha1 = "298d7e2231660f40c003c2ed3140decf3f53085f";
      };
    };
    "https-proxy-agent-0.3.6" = {
      name = "https-proxy-agent";
      packageName = "https-proxy-agent";
      version = "0.3.6";
      src = fetchurl {
        url = "https://registry.npmjs.org/https-proxy-agent/-/https-proxy-agent-0.3.6.tgz";
        sha1 = "713fa38e5d353f50eb14a342febe29033ed1619b";
      };
    };
    "uuid-3.1.0" = {
      name = "uuid";
      packageName = "uuid";
      version = "3.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/uuid/-/uuid-3.1.0.tgz";
        sha512 = "3x5mi85l1559nkb35pfksjjgiyfyqrcvmcf0nly1xjl1kb0d37jnxd6sk0b8d331waadnqbf60nfssb563x9pvnjcw87lrh976sv18c";
      };
    };
    "ws-1.1.5" = {
      name = "ws";
      packageName = "ws";
      version = "1.1.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/ws/-/ws-1.1.5.tgz";
        sha512 = "3iv2yz706h7wyg563jsfjdykkkxs8j49vz60r6qx5by0npfhs98rgc114kdqs15sc52mldscc22bkfpkrs08cwlqaxx8lfdjn5alwm3";
      };
    };
    "agent-base-1.0.2" = {
      name = "agent-base";
      packageName = "agent-base";
      version = "1.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/agent-base/-/agent-base-1.0.2.tgz";
        sha1 = "6890d3fb217004b62b70f8928e0fae5f8952a706";
      };
    };
    "extend-3.0.1" = {
      name = "extend";
      packageName = "extend";
      version = "3.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/extend/-/extend-3.0.1.tgz";
        sha1 = "a755ea7bc1adfcc5a31ce7e762dbaadc5e636444";
      };
    };
    "options-0.0.6" = {
      name = "options";
      packageName = "options";
      version = "0.0.6";
      src = fetchurl {
        url = "https://registry.npmjs.org/options/-/options-0.0.6.tgz";
        sha1 = "ec22d312806bb53e731773e7cdaefcf1c643128f";
      };
    };
    "ultron-1.0.2" = {
      name = "ultron";
      packageName = "ultron";
      version = "1.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/ultron/-/ultron-1.0.2.tgz";
        sha1 = "ace116ab557cd197386a4e88f4685378c8b2e4fa";
      };
    };
    "crypto-md5-1.0.0" = {
      name = "crypto-md5";
      packageName = "crypto-md5";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/crypto-md5/-/crypto-md5-1.0.0.tgz";
        sha1 = "ccc8da750c753c7edcbabc542967472a384e86bb";
      };
    };
    "extend-2.0.1" = {
      name = "extend";
      packageName = "extend";
      version = "2.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/extend/-/extend-2.0.1.tgz";
        sha1 = "1ee8010689e7395ff9448241c98652bc759a8260";
      };
    };
    "knox-0.9.2" = {
      name = "knox";
      packageName = "knox";
      version = "0.9.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/knox/-/knox-0.9.2.tgz";
        sha1 = "3736593669e24f024fdaf723b6a1dc4afd839a71";
      };
    };
    "queue-async-1.2.1" = {
      name = "queue-async";
      packageName = "queue-async";
      version = "1.2.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/queue-async/-/queue-async-1.2.1.tgz";
        sha1 = "0582e01dae253258cf576fc2a35db96fca847f6f";
      };
    };
    "retry-me-1.0.0" = {
      name = "retry-me";
      packageName = "retry-me";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/retry-me/-/retry-me-1.0.0.tgz";
        sha1 = "c120739fabd2dba30df9573db5888362afd440d4";
      };
    };
    "xml2js-0.4.19" = {
      name = "xml2js";
      packageName = "xml2js";
      version = "0.4.19";
      src = fetchurl {
        url = "https://registry.npmjs.org/xml2js/-/xml2js-0.4.19.tgz";
        sha512 = "3skianymbfq4rg2v5c1vwsz2kmxfik60qa892wh6a3rydd1wrv3l4vgyr8v4wd8krdf42jbmq7blp0ksbmwm332q5yr922fj8jngiks";
      };
    };
    "debug-1.0.5" = {
      name = "debug";
      packageName = "debug";
      version = "1.0.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/debug/-/debug-1.0.5.tgz";
        sha1 = "f7241217430f99dec4c2b473eab92228e874c2ac";
      };
    };
    "stream-counter-1.0.0" = {
      name = "stream-counter";
      packageName = "stream-counter";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/stream-counter/-/stream-counter-1.0.0.tgz";
        sha1 = "91cf2569ce4dc5061febcd7acb26394a5a114751";
      };
    };
    "once-1.4.0" = {
      name = "once";
      packageName = "once";
      version = "1.4.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/once/-/once-1.4.0.tgz";
        sha1 = "583b1aa775961d4b113ac17d9c50baef9dd76bd1";
      };
    };
    "ms-2.0.0" = {
      name = "ms";
      packageName = "ms";
      version = "2.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/ms/-/ms-2.0.0.tgz";
        sha1 = "5608aeadfc00be6c2901df5f9861788de0d597c8";
      };
    };
    "wrappy-1.0.2" = {
      name = "wrappy";
      packageName = "wrappy";
      version = "1.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz";
        sha1 = "b5243d8f3ec1aa35f1364605bc0d1036e30ab69f";
      };
    };
    "retry-0.6.1" = {
      name = "retry";
      packageName = "retry";
      version = "0.6.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/retry/-/retry-0.6.1.tgz";
        sha1 = "fdc90eed943fde11b893554b8cc63d0e899ba918";
      };
    };
    "xtend-4.0.1" = {
      name = "xtend";
      packageName = "xtend";
      version = "4.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/xtend/-/xtend-4.0.1.tgz";
        sha1 = "a5c6d532be656e23db820efb943a1f04998d63af";
      };
    };
    "sax-1.2.4" = {
      name = "sax";
      packageName = "sax";
      version = "1.2.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/sax/-/sax-1.2.4.tgz";
        sha512 = "1dn291mjsda42w8kldlbmngk6dhjxfbvvd5lckyqmwbjaj6069iq3wx0nvcfglwnpddz2qa93lzf4hv77iz43bd2qixa079sjzl799n";
      };
    };
    "xmlbuilder-9.0.4" = {
      name = "xmlbuilder";
      packageName = "xmlbuilder";
      version = "9.0.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/xmlbuilder/-/xmlbuilder-9.0.4.tgz";
        sha1 = "519cb4ca686d005a8420d3496f3f0caeecca580f";
      };
    };
    "lodash-4.17.4" = {
      name = "lodash";
      packageName = "lodash";
      version = "4.17.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/lodash/-/lodash-4.17.4.tgz";
        sha1 = "78203a4d1c328ae1d86dca6460e369b57f4055ae";
      };
    };
    "ansi-styles-2.2.1" = {
      name = "ansi-styles";
      packageName = "ansi-styles";
      version = "2.2.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/ansi-styles/-/ansi-styles-2.2.1.tgz";
        sha1 = "b432dd3358b634cf75e1e4664368240533c1ddbe";
      };
    };
    "escape-string-regexp-1.0.5" = {
      name = "escape-string-regexp";
      packageName = "escape-string-regexp";
      version = "1.0.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz";
        sha1 = "1b61c0562190a8dff6ae3bb2cf0200ca130b86d4";
      };
    };
    "has-ansi-2.0.0" = {
      name = "has-ansi";
      packageName = "has-ansi";
      version = "2.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/has-ansi/-/has-ansi-2.0.0.tgz";
        sha1 = "34f5049ce1ecdf2b0649af3ef24e45ed35416d91";
      };
    };
    "strip-ansi-3.0.1" = {
      name = "strip-ansi";
      packageName = "strip-ansi";
      version = "3.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/strip-ansi/-/strip-ansi-3.0.1.tgz";
        sha1 = "6a385fb8853d952d5ff05d0e8aaf94278dc63dcf";
      };
    };
    "supports-color-2.0.0" = {
      name = "supports-color";
      packageName = "supports-color";
      version = "2.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/supports-color/-/supports-color-2.0.0.tgz";
        sha1 = "535d045ce6b6363fa40117084629995e9df324c7";
      };
    };
    "ansi-regex-2.1.1" = {
      name = "ansi-regex";
      packageName = "ansi-regex";
      version = "2.1.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/ansi-regex/-/ansi-regex-2.1.1.tgz";
        sha1 = "c3b33ab5ee360d86e0e628f0468ae7ef27d654df";
      };
    };
    "data2xml-0.9.0" = {
      name = "data2xml";
      packageName = "data2xml";
      version = "0.9.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/data2xml/-/data2xml-0.9.0.tgz";
        sha1 = "ed1a2a335953936a4c40ea95842230004434be00";
      };
    };
    "xml2js-0.2.8" = {
      name = "xml2js";
      packageName = "xml2js";
      version = "0.2.8";
      src = fetchurl {
        url = "https://registry.npmjs.org/xml2js/-/xml2js-0.2.8.tgz";
        sha1 = "9b81690931631ff09d1957549faf54f4f980b3c2";
      };
    };
    "sax-0.5.8" = {
      name = "sax";
      packageName = "sax";
      version = "0.5.8";
      src = fetchurl {
        url = "https://registry.npmjs.org/sax/-/sax-0.5.8.tgz";
        sha1 = "d472db228eb331c2506b0e8c15524adb939d12c1";
      };
    };
    "through-2.3.8" = {
      name = "through";
      packageName = "through";
      version = "2.3.8";
      src = fetchurl {
        url = "https://registry.npmjs.org/through/-/through-2.3.8.tgz";
        sha1 = "0dd4c9ffaabc357960b1b724115d7e0e86a2e1f5";
      };
    };
    "duplexer-0.1.1" = {
      name = "duplexer";
      packageName = "duplexer";
      version = "0.1.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/duplexer/-/duplexer-0.1.1.tgz";
        sha1 = "ace6ff808c1ce66b57d1ebf97977acb02334cfc1";
      };
    };
    "from-0.1.7" = {
      name = "from";
      packageName = "from";
      version = "0.1.7";
      src = fetchurl {
        url = "https://registry.npmjs.org/from/-/from-0.1.7.tgz";
        sha1 = "83c60afc58b9c56997007ed1a768b3ab303a44fe";
      };
    };
    "map-stream-0.1.0" = {
      name = "map-stream";
      packageName = "map-stream";
      version = "0.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/map-stream/-/map-stream-0.1.0.tgz";
        sha1 = "e56aa94c4c8055a16404a0674b78f215f7c8e194";
      };
    };
    "pause-stream-0.0.11" = {
      name = "pause-stream";
      packageName = "pause-stream";
      version = "0.0.11";
      src = fetchurl {
        url = "https://registry.npmjs.org/pause-stream/-/pause-stream-0.0.11.tgz";
        sha1 = "fe5a34b0cbce12b5aa6a2b403ee2e73b602f1445";
      };
    };
    "split-0.3.3" = {
      name = "split";
      packageName = "split";
      version = "0.3.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/split/-/split-0.3.3.tgz";
        sha1 = "cd0eea5e63a211dfff7eb0f091c4133e2d0dd28f";
      };
    };
    "stream-combiner-0.0.4" = {
      name = "stream-combiner";
      packageName = "stream-combiner";
      version = "0.0.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/stream-combiner/-/stream-combiner-0.0.4.tgz";
        sha1 = "4d5e433c185261dde623ca3f44c586bcf5c4ad14";
      };
    };
    "argparse-1.0.9" = {
      name = "argparse";
      packageName = "argparse";
      version = "1.0.9";
      src = fetchurl {
        url = "https://registry.npmjs.org/argparse/-/argparse-1.0.9.tgz";
        sha1 = "73d83bc263f86e97f8cc4f6bae1b0e90a7d22c86";
      };
    };
    "esprima-4.0.0" = {
      name = "esprima";
      packageName = "esprima";
      version = "4.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/esprima/-/esprima-4.0.0.tgz";
        sha512 = "27mkhd94y9vrr8pb97br0ym5h85rawwb0biswgwdfp31x0387y12k9p9598bi4fc83fif6crfzqiqmmjs4x7gcb22ml3z1fldqm7yx1";
      };
    };
    "sprintf-js-1.0.3" = {
      name = "sprintf-js";
      packageName = "sprintf-js";
      version = "1.0.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/sprintf-js/-/sprintf-js-1.0.3.tgz";
        sha1 = "04e6926f662895354f3dd015203633b857297e2c";
      };
    };
    "mime-db-1.30.0" = {
      name = "mime-db";
      packageName = "mime-db";
      version = "1.30.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/mime-db/-/mime-db-1.30.0.tgz";
        sha1 = "74c643da2dd9d6a45399963465b26d5ca7d71f01";
      };
    };
    "read-1.0.7" = {
      name = "read";
      packageName = "read";
      version = "1.0.7";
      src = fetchurl {
        url = "https://registry.npmjs.org/read/-/read-1.0.7.tgz";
        sha1 = "b3da19bd052431a97671d44a42634adf710b40c4";
      };
    };
    "mute-stream-0.0.7" = {
      name = "mute-stream";
      packageName = "mute-stream";
      version = "0.0.7";
      src = fetchurl {
        url = "https://registry.npmjs.org/mute-stream/-/mute-stream-0.0.7.tgz";
        sha1 = "3075ce93bc21b8fab43e1bc4da7e8115ed1e7bab";
      };
    };
    "graceful-fs-4.1.11" = {
      name = "graceful-fs";
      packageName = "graceful-fs";
      version = "4.1.11";
      src = fetchurl {
        url = "https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.1.11.tgz";
        sha1 = "0e8bdfe4d1ddb8854d64e04ea7c00e2a026e5658";
      };
    };
    "minimatch-3.0.4" = {
      name = "minimatch";
      packageName = "minimatch";
      version = "3.0.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/minimatch/-/minimatch-3.0.4.tgz";
        sha512 = "1879a3j85h92ypvb7lpv1dqpcxl49rqnbgs5la18zmj1yqhwl60c2m74254wbr5pp3znckqpkg9dvjyrz6hfz8b9vag5a3j910db4f8";
      };
    };
    "readable-stream-2.3.3" = {
      name = "readable-stream";
      packageName = "readable-stream";
      version = "2.3.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/readable-stream/-/readable-stream-2.3.3.tgz";
        sha512 = "1wlizkv2wnz2nyb0lfxgs1m27zzcvasp3n5cfrd7hm4ch1wn79df2nbhzfadba5qqdfb28vhmw3drhp46vk2q6xk524qagvr76v7slv";
      };
    };
    "set-immediate-shim-1.0.1" = {
      name = "set-immediate-shim";
      packageName = "set-immediate-shim";
      version = "1.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/set-immediate-shim/-/set-immediate-shim-1.0.1.tgz";
        sha1 = "4b2b1b27eb808a9f8dcc481a58e5e56f599f3f61";
      };
    };
    "brace-expansion-1.1.8" = {
      name = "brace-expansion";
      packageName = "brace-expansion";
      version = "1.1.8";
      src = fetchurl {
        url = "https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.8.tgz";
        sha1 = "c07b211c7c952ec1f8efd51a77ef0d1d3990a292";
      };
    };
    "balanced-match-1.0.0" = {
      name = "balanced-match";
      packageName = "balanced-match";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.0.tgz";
        sha1 = "89b4d199ab2bee49de164ea02b89ce462d71b767";
      };
    };
    "concat-map-0.0.1" = {
      name = "concat-map";
      packageName = "concat-map";
      version = "0.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz";
        sha1 = "d8a96bd77fd68df7793a73036a3ba0d5405d477b";
      };
    };
    "core-util-is-1.0.2" = {
      name = "core-util-is";
      packageName = "core-util-is";
      version = "1.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/core-util-is/-/core-util-is-1.0.2.tgz";
        sha1 = "b5fd54220aa2bc5ab57aab7140c940754503c1a7";
      };
    };
    "inherits-2.0.3" = {
      name = "inherits";
      packageName = "inherits";
      version = "2.0.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/inherits/-/inherits-2.0.3.tgz";
        sha1 = "633c2c83e3da42a502f52466022480f4208261de";
      };
    };
    "isarray-1.0.0" = {
      name = "isarray";
      packageName = "isarray";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz";
        sha1 = "bb935d48582cba168c06834957a54a3e07124f11";
      };
    };
    "process-nextick-args-1.0.7" = {
      name = "process-nextick-args";
      packageName = "process-nextick-args";
      version = "1.0.7";
      src = fetchurl {
        url = "https://registry.npmjs.org/process-nextick-args/-/process-nextick-args-1.0.7.tgz";
        sha1 = "150e20b756590ad3f91093f25a4f2ad8bff30ba3";
      };
    };
    "safe-buffer-5.1.1" = {
      name = "safe-buffer";
      packageName = "safe-buffer";
      version = "5.1.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.1.tgz";
        sha512 = "1p28rllll1w65yzq5azi4izx962399xdsdlfbaynn7vmp981hiss05jhiy9hm7sbbfk3b4dhlcv0zy07fc59mnc07hdv6wcgqkcvawh";
      };
    };
    "string_decoder-1.0.3" = {
      name = "string_decoder";
      packageName = "string_decoder";
      version = "1.0.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/string_decoder/-/string_decoder-1.0.3.tgz";
        sha512 = "22vw5mmwlyblqc2zyqwl39wyhyahhpiyknim8iz5fk6xi002x777gkswiq8fh297djs5ii4pgrys57wq33hr5zf3xfd0d7kjxkzl0g0";
      };
    };
    "util-deprecate-1.0.2" = {
      name = "util-deprecate";
      packageName = "util-deprecate";
      version = "1.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz";
        sha1 = "450d4dc9fa70de732762fbd2d4a28981419a0ccf";
      };
    };
    "aws-sign2-0.7.0" = {
      name = "aws-sign2";
      packageName = "aws-sign2";
      version = "0.7.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/aws-sign2/-/aws-sign2-0.7.0.tgz";
        sha1 = "b46e890934a9591f2d2f6f86d7e6a9f1b3fe76a8";
      };
    };
    "aws4-1.6.0" = {
      name = "aws4";
      packageName = "aws4";
      version = "1.6.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/aws4/-/aws4-1.6.0.tgz";
        sha1 = "83ef5ca860b2b32e4a0deedee8c771b9db57471e";
      };
    };
    "caseless-0.12.0" = {
      name = "caseless";
      packageName = "caseless";
      version = "0.12.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/caseless/-/caseless-0.12.0.tgz";
        sha1 = "1b681c21ff84033c826543090689420d187151dc";
      };
    };
    "combined-stream-1.0.5" = {
      name = "combined-stream";
      packageName = "combined-stream";
      version = "1.0.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/combined-stream/-/combined-stream-1.0.5.tgz";
        sha1 = "938370a57b4a51dea2c77c15d5c5fdf895164009";
      };
    };
    "forever-agent-0.6.1" = {
      name = "forever-agent";
      packageName = "forever-agent";
      version = "0.6.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/forever-agent/-/forever-agent-0.6.1.tgz";
        sha1 = "fbc71f0c41adeb37f96c577ad1ed42d8fdacca91";
      };
    };
    "form-data-2.3.1" = {
      name = "form-data";
      packageName = "form-data";
      version = "2.3.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/form-data/-/form-data-2.3.1.tgz";
        sha1 = "6fb94fbd71885306d73d15cc497fe4cc4ecd44bf";
      };
    };
    "har-validator-5.0.3" = {
      name = "har-validator";
      packageName = "har-validator";
      version = "5.0.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/har-validator/-/har-validator-5.0.3.tgz";
        sha1 = "ba402c266194f15956ef15e0fcf242993f6a7dfd";
      };
    };
    "hawk-6.0.2" = {
      name = "hawk";
      packageName = "hawk";
      version = "6.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/hawk/-/hawk-6.0.2.tgz";
        sha512 = "1nl2hjr2mnhj5jlaz8mh54z7acwz5j5idkch04qgjk78756gw5d0fjk4a2immil5ij9ijdssb9ndpryvnh2xpcbgcjv8lxybn330als";
      };
    };
    "http-signature-1.2.0" = {
      name = "http-signature";
      packageName = "http-signature";
      version = "1.2.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/http-signature/-/http-signature-1.2.0.tgz";
        sha1 = "9aecd925114772f3d95b65a60abb8f7c18fbace1";
      };
    };
    "is-typedarray-1.0.0" = {
      name = "is-typedarray";
      packageName = "is-typedarray";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/is-typedarray/-/is-typedarray-1.0.0.tgz";
        sha1 = "e479c80858df0c1b11ddda6940f96011fcda4a9a";
      };
    };
    "isstream-0.1.2" = {
      name = "isstream";
      packageName = "isstream";
      version = "0.1.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/isstream/-/isstream-0.1.2.tgz";
        sha1 = "47e63f7af55afa6f92e1500e690eb8b8529c099a";
      };
    };
    "json-stringify-safe-5.0.1" = {
      name = "json-stringify-safe";
      packageName = "json-stringify-safe";
      version = "5.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz";
        sha1 = "1296a2d58fd45f19a0f6ce01d65701e2c735b6eb";
      };
    };
    "oauth-sign-0.8.2" = {
      name = "oauth-sign";
      packageName = "oauth-sign";
      version = "0.8.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/oauth-sign/-/oauth-sign-0.8.2.tgz";
        sha1 = "46a6ab7f0aead8deae9ec0565780b7d4efeb9d43";
      };
    };
    "performance-now-2.1.0" = {
      name = "performance-now";
      packageName = "performance-now";
      version = "2.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/performance-now/-/performance-now-2.1.0.tgz";
        sha1 = "6309f4e0e5fa913ec1c69307ae364b4b377c9e7b";
      };
    };
    "qs-6.5.1" = {
      name = "qs";
      packageName = "qs";
      version = "6.5.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/qs/-/qs-6.5.1.tgz";
        sha512 = "3waqapyj1k4g135sgj636rmswiaixq19is1rw0rpv4qp6k7dl0a9nwy06m7yl5lbdk9p6xpwwngnggbzlzaz6rh11c86j2nvnnf273r";
      };
    };
    "stringstream-0.0.5" = {
      name = "stringstream";
      packageName = "stringstream";
      version = "0.0.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/stringstream/-/stringstream-0.0.5.tgz";
        sha1 = "4e484cd4de5a0bbbee18e46307710a8a81621878";
      };
    };
    "tough-cookie-2.3.3" = {
      name = "tough-cookie";
      packageName = "tough-cookie";
      version = "2.3.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/tough-cookie/-/tough-cookie-2.3.3.tgz";
        sha1 = "0b618a5565b6dea90bf3425d04d55edc475a7561";
      };
    };
    "tunnel-agent-0.6.0" = {
      name = "tunnel-agent";
      packageName = "tunnel-agent";
      version = "0.6.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.6.0.tgz";
        sha1 = "27a5dea06b36b04a0a9966774b290868f0fc40fd";
      };
    };
    "delayed-stream-1.0.0" = {
      name = "delayed-stream";
      packageName = "delayed-stream";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz";
        sha1 = "df3ae199acadfb7d440aaae0b29e2272b24ec619";
      };
    };
    "asynckit-0.4.0" = {
      name = "asynckit";
      packageName = "asynckit";
      version = "0.4.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/asynckit/-/asynckit-0.4.0.tgz";
        sha1 = "c79ed97f7f34cb8f2ba1bc9790bcc366474b4b79";
      };
    };
    "ajv-5.5.0" = {
      name = "ajv";
      packageName = "ajv";
      version = "5.5.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/ajv/-/ajv-5.5.0.tgz";
        sha1 = "eb2840746e9dc48bd5e063a36e3fd400c5eab5a9";
      };
    };
    "har-schema-2.0.0" = {
      name = "har-schema";
      packageName = "har-schema";
      version = "2.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/har-schema/-/har-schema-2.0.0.tgz";
        sha1 = "a94c2224ebcac04782a0d9035521f24735b7ec92";
      };
    };
    "co-4.6.0" = {
      name = "co";
      packageName = "co";
      version = "4.6.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/co/-/co-4.6.0.tgz";
        sha1 = "6ea6bdf3d853ae54ccb8e47bfa0bf3f9031fb184";
      };
    };
    "fast-deep-equal-1.0.0" = {
      name = "fast-deep-equal";
      packageName = "fast-deep-equal";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/fast-deep-equal/-/fast-deep-equal-1.0.0.tgz";
        sha1 = "96256a3bc975595eb36d82e9929d060d893439ff";
      };
    };
    "fast-json-stable-stringify-2.0.0" = {
      name = "fast-json-stable-stringify";
      packageName = "fast-json-stable-stringify";
      version = "2.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/fast-json-stable-stringify/-/fast-json-stable-stringify-2.0.0.tgz";
        sha1 = "d5142c0caee6b1189f87d3a76111064f86c8bbf2";
      };
    };
    "json-schema-traverse-0.3.1" = {
      name = "json-schema-traverse";
      packageName = "json-schema-traverse";
      version = "0.3.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-0.3.1.tgz";
        sha1 = "349a6d44c53a51de89b40805c5d5e59b417d3340";
      };
    };
    "hoek-4.2.0" = {
      name = "hoek";
      packageName = "hoek";
      version = "4.2.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/hoek/-/hoek-4.2.0.tgz";
        sha512 = "2cz0q3nnv67drgaw2rm7q57r9rgdax1qa0n4z46is7db1w8vwmh574xcr0d73xl5lg80vb85xg2gdhxzh9gbllagp7xk2q228pw4idz";
      };
    };
    "boom-4.3.1" = {
      name = "boom";
      packageName = "boom";
      version = "4.3.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/boom/-/boom-4.3.1.tgz";
        sha1 = "4f8a3005cb4a7e3889f749030fd25b96e01d2e31";
      };
    };
    "cryptiles-3.1.2" = {
      name = "cryptiles";
      packageName = "cryptiles";
      version = "3.1.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/cryptiles/-/cryptiles-3.1.2.tgz";
        sha1 = "a89fbb220f5ce25ec56e8c4aa8a4fd7b5b0d29fe";
      };
    };
    "sntp-2.1.0" = {
      name = "sntp";
      packageName = "sntp";
      version = "2.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/sntp/-/sntp-2.1.0.tgz";
        sha512 = "0k2smmr24w5hb1cpql6vcgh58vzp4pmh9anf0bgz3arlsgq1mapnlq9fjqr6xs10aq1cmxaw987fwknqi62frax0fvs9bj3q3kmpg8l";
      };
    };
    "boom-5.2.0" = {
      name = "boom";
      packageName = "boom";
      version = "5.2.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/boom/-/boom-5.2.0.tgz";
        sha512 = "19h20yqpvca08dns1rs4f057f10w63v0snxfml4h5khsk266x3x1im0w72bza4k2xn0kfz6jlv001dhcvxsjr09bmbqnysils9m7437";
      };
    };
    "assert-plus-1.0.0" = {
      name = "assert-plus";
      packageName = "assert-plus";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/assert-plus/-/assert-plus-1.0.0.tgz";
        sha1 = "f12e0f3c5d77b0b1cdd9146942e4e96c1e4dd525";
      };
    };
    "jsprim-1.4.1" = {
      name = "jsprim";
      packageName = "jsprim";
      version = "1.4.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/jsprim/-/jsprim-1.4.1.tgz";
        sha1 = "313e66bc1e5cc06e438bc1b7499c2e5c56acb6a2";
      };
    };
    "sshpk-1.13.1" = {
      name = "sshpk";
      packageName = "sshpk";
      version = "1.13.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/sshpk/-/sshpk-1.13.1.tgz";
        sha1 = "512df6da6287144316dc4c18fe1cf1d940739be3";
      };
    };
    "extsprintf-1.3.0" = {
      name = "extsprintf";
      packageName = "extsprintf";
      version = "1.3.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/extsprintf/-/extsprintf-1.3.0.tgz";
        sha1 = "96918440e3041a7a414f8c52e3c574eb3c3e1e05";
      };
    };
    "json-schema-0.2.3" = {
      name = "json-schema";
      packageName = "json-schema";
      version = "0.2.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/json-schema/-/json-schema-0.2.3.tgz";
        sha1 = "b480c892e59a2f05954ce727bd3f2a4e882f9e13";
      };
    };
    "verror-1.10.0" = {
      name = "verror";
      packageName = "verror";
      version = "1.10.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/verror/-/verror-1.10.0.tgz";
        sha1 = "3a105ca17053af55d6e270c1f8288682e18da400";
      };
    };
    "asn1-0.2.3" = {
      name = "asn1";
      packageName = "asn1";
      version = "0.2.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/asn1/-/asn1-0.2.3.tgz";
        sha1 = "dac8787713c9966849fc8180777ebe9c1ddf3b86";
      };
    };
    "dashdash-1.14.1" = {
      name = "dashdash";
      packageName = "dashdash";
      version = "1.14.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/dashdash/-/dashdash-1.14.1.tgz";
        sha1 = "853cfa0f7cbe2fed5de20326b8dd581035f6e2f0";
      };
    };
    "getpass-0.1.7" = {
      name = "getpass";
      packageName = "getpass";
      version = "0.1.7";
      src = fetchurl {
        url = "https://registry.npmjs.org/getpass/-/getpass-0.1.7.tgz";
        sha1 = "5eff8e3e684d569ae4cb2b1282604e8ba62149fa";
      };
    };
    "jsbn-0.1.1" = {
      name = "jsbn";
      packageName = "jsbn";
      version = "0.1.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/jsbn/-/jsbn-0.1.1.tgz";
        sha1 = "a5e654c2e5a2deb5f201d96cefbca80c0ef2f513";
      };
    };
    "tweetnacl-0.14.5" = {
      name = "tweetnacl";
      packageName = "tweetnacl";
      version = "0.14.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/tweetnacl/-/tweetnacl-0.14.5.tgz";
        sha1 = "5ae68177f192d4456269d108afa93ff8743f4f64";
      };
    };
    "ecc-jsbn-0.1.1" = {
      name = "ecc-jsbn";
      packageName = "ecc-jsbn";
      version = "0.1.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/ecc-jsbn/-/ecc-jsbn-0.1.1.tgz";
        sha1 = "0fc73a9ed5f0d53c38193398523ef7e543777505";
      };
    };
    "bcrypt-pbkdf-1.0.1" = {
      name = "bcrypt-pbkdf";
      packageName = "bcrypt-pbkdf";
      version = "1.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/bcrypt-pbkdf/-/bcrypt-pbkdf-1.0.1.tgz";
        sha1 = "63bc5dcb61331b92bc05fd528953c33462a06f8d";
      };
    };
    "punycode-1.4.1" = {
      name = "punycode";
      packageName = "punycode";
      version = "1.4.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/punycode/-/punycode-1.4.1.tgz";
        sha1 = "c0d5a63b2718800ad8e1eb0fa5269c84dd41845e";
      };
    };
    "jsonify-0.0.0" = {
      name = "jsonify";
      packageName = "jsonify";
      version = "0.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/jsonify/-/jsonify-0.0.0.tgz";
        sha1 = "2c74b6ee41d93ca51b7b5aaee8f503631d252a73";
      };
    };
    "array-filter-0.0.1" = {
      name = "array-filter";
      packageName = "array-filter";
      version = "0.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/array-filter/-/array-filter-0.0.1.tgz";
        sha1 = "7da8cf2e26628ed732803581fd21f67cacd2eeec";
      };
    };
    "array-reduce-0.0.0" = {
      name = "array-reduce";
      packageName = "array-reduce";
      version = "0.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/array-reduce/-/array-reduce-0.0.0.tgz";
        sha1 = "173899d3ffd1c7d9383e4479525dbe278cab5f2b";
      };
    };
    "array-map-0.0.0" = {
      name = "array-map";
      packageName = "array-map";
      version = "0.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/array-map/-/array-map-0.0.0.tgz";
        sha1 = "88a2bab73d1cf7bcd5c1b118a003f66f665fa662";
      };
    };
  };
  args = {
    name = "_at_atlassian_slash_micros-cli";
    packageName = "@atlassian/micros-cli";
    version = "5.16.5";
    src = srcOnly {
      name = "micros-cli-patched";
      src = fetchgitPrivate {
        url = "ssh://git@stash.atlassian.com:7997/micros/micros-cli.git";
        rev = "bb128be238769786c1130e2bd870d3f8dbf0d075";
        sha256 = "1xf08frgi0yj2sxnj6ghx5114cb9snri4zk4sl1crvripia4sa0m";
      };
      patches = [ ./netrc.patch ];
    };
    dependencies = [
      sources."@atlassian/inject-environment-into-object-1.1.1"
      sources."netrc-0.1.4"
      (sources."@atlassian/ws-4.1.0" // {
        dependencies = [
          sources."clone-1.0.3"
          (sources."https-proxy-agent-0.3.6" // {
            dependencies = [
              sources."agent-base-1.0.2"
              sources."extend-3.0.1"
            ];
          })
          sources."uuid-3.1.0"
          (sources."ws-1.1.5" // {
            dependencies = [
              sources."options-0.0.6"
              sources."ultron-1.0.2"
            ];
          })
        ];
      })
      (sources."alamo-0.1.4" // {
        dependencies = [
          sources."crypto-md5-1.0.0"
          sources."extend-2.0.1"
          (sources."knox-0.9.2" // {
            dependencies = [
              (sources."debug-1.0.5" // {
                dependencies = [
                  sources."ms-2.0.0"
                ];
              })
              sources."stream-counter-1.0.0"
              (sources."once-1.4.0" // {
                dependencies = [
                  sources."wrappy-1.0.2"
                ];
              })
            ];
          })
          sources."queue-async-1.2.1"
          (sources."retry-me-1.0.0" // {
            dependencies = [
              sources."retry-0.6.1"
              sources."xtend-4.0.1"
            ];
          })
          (sources."xml2js-0.4.19" // {
            dependencies = [
              sources."sax-1.2.4"
              sources."xmlbuilder-9.0.4"
            ];
          })
        ];
      })
      (sources."async-2.6.0" // {
        dependencies = [
          sources."lodash-4.17.4"
        ];
      })
      sources."awscred-1.2.0"
      sources."bluebird-3.5.1"
      (sources."chalk-1.1.3" // {
        dependencies = [
          sources."ansi-styles-2.2.1"
          sources."escape-string-regexp-1.0.5"
          (sources."has-ansi-2.0.0" // {
            dependencies = [
              sources."ansi-regex-2.1.1"
            ];
          })
          (sources."strip-ansi-3.0.1" // {
            dependencies = [
              sources."ansi-regex-2.1.1"
            ];
          })
          sources."supports-color-2.0.0"
        ];
      })
      sources."ci-info-1.1.2"
      sources."cli-spinner-0.2.7"
      sources."clone-2.1.1"
      (sources."cloudfront-0.4.1" // {
        dependencies = [
          sources."data2xml-0.9.0"
          (sources."xml2js-0.2.8" // {
            dependencies = [
              sources."sax-0.5.8"
            ];
          })
        ];
      })
      sources."colors-1.1.2"
      (sources."debug-2.6.9" // {
        dependencies = [
          sources."ms-2.0.0"
        ];
      })
      (sources."event-stream-3.3.4" // {
        dependencies = [
          sources."through-2.3.8"
          sources."duplexer-0.1.1"
          sources."from-0.1.7"
          sources."map-stream-0.1.0"
          sources."pause-stream-0.0.11"
          sources."split-0.3.3"
          sources."stream-combiner-0.0.4"
        ];
      })
      (sources."js-yaml-3.10.0" // {
        dependencies = [
          (sources."argparse-1.0.9" // {
            dependencies = [
              sources."sprintf-js-1.0.3"
            ];
          })
          sources."esprima-4.0.0"
        ];
      })
      sources."mime-1.6.0"
      (sources."mime-types-2.1.17" // {
        dependencies = [
          sources."mime-db-1.30.0"
        ];
      })
      sources."moment-2.19.2"
      sources."npm-5.6.0"
      sources."priorityqueuejs-1.0.0"
      (sources."promptly-2.2.0" // {
        dependencies = [
          (sources."read-1.0.7" // {
            dependencies = [
              sources."mute-stream-0.0.7"
            ];
          })
        ];
      })
      (sources."readdirp-2.1.0" // {
        dependencies = [
          sources."graceful-fs-4.1.11"
          (sources."minimatch-3.0.4" // {
            dependencies = [
              (sources."brace-expansion-1.1.8" // {
                dependencies = [
                  sources."balanced-match-1.0.0"
                  sources."concat-map-0.0.1"
                ];
              })
            ];
          })
          (sources."readable-stream-2.3.3" // {
            dependencies = [
              sources."core-util-is-1.0.2"
              sources."inherits-2.0.3"
              sources."isarray-1.0.0"
              sources."process-nextick-args-1.0.7"
              sources."safe-buffer-5.1.1"
              sources."string_decoder-1.0.3"
              sources."util-deprecate-1.0.2"
            ];
          })
          sources."set-immediate-shim-1.0.1"
        ];
      })
      (sources."request-2.83.0" // {
        dependencies = [
          sources."aws-sign2-0.7.0"
          sources."aws4-1.6.0"
          sources."caseless-0.12.0"
          (sources."combined-stream-1.0.5" // {
            dependencies = [
              sources."delayed-stream-1.0.0"
            ];
          })
          sources."extend-3.0.1"
          sources."forever-agent-0.6.1"
          (sources."form-data-2.3.1" // {
            dependencies = [
              sources."asynckit-0.4.0"
            ];
          })
          (sources."har-validator-5.0.3" // {
            dependencies = [
              (sources."ajv-5.5.0" // {
                dependencies = [
                  sources."co-4.6.0"
                  sources."fast-deep-equal-1.0.0"
                  sources."fast-json-stable-stringify-2.0.0"
                  sources."json-schema-traverse-0.3.1"
                ];
              })
              sources."har-schema-2.0.0"
            ];
          })
          (sources."hawk-6.0.2" // {
            dependencies = [
              sources."hoek-4.2.0"
              sources."boom-4.3.1"
              (sources."cryptiles-3.1.2" // {
                dependencies = [
                  sources."boom-5.2.0"
                ];
              })
              sources."sntp-2.1.0"
            ];
          })
          (sources."http-signature-1.2.0" // {
            dependencies = [
              sources."assert-plus-1.0.0"
              (sources."jsprim-1.4.1" // {
                dependencies = [
                  sources."extsprintf-1.3.0"
                  sources."json-schema-0.2.3"
                  (sources."verror-1.10.0" // {
                    dependencies = [
                      sources."core-util-is-1.0.2"
                    ];
                  })
                ];
              })
              (sources."sshpk-1.13.1" // {
                dependencies = [
                  sources."asn1-0.2.3"
                  sources."dashdash-1.14.1"
                  sources."getpass-0.1.7"
                  sources."jsbn-0.1.1"
                  sources."tweetnacl-0.14.5"
                  sources."ecc-jsbn-0.1.1"
                  sources."bcrypt-pbkdf-1.0.1"
                ];
              })
            ];
          })
          sources."is-typedarray-1.0.0"
          sources."isstream-0.1.2"
          sources."json-stringify-safe-5.0.1"
          sources."oauth-sign-0.8.2"
          sources."performance-now-2.1.0"
          sources."qs-6.5.1"
          sources."safe-buffer-5.1.1"
          sources."stringstream-0.0.5"
          (sources."tough-cookie-2.3.3" // {
            dependencies = [
              sources."punycode-1.4.1"
            ];
          })
          sources."tunnel-agent-0.6.0"
          sources."uuid-3.1.0"
        ];
      })
      (sources."shell-quote-1.6.1" // {
        dependencies = [
          sources."jsonify-0.0.0"
          sources."array-filter-0.0.1"
          sources."array-reduce-0.0.0"
          sources."array-map-0.0.0"
        ];
      })
      sources."shortid-2.2.8"
      sources."stream-ext-0.0.1"
      sources."underscore-1.8.3"
      sources."validator-6.3.0"
    ];
    buildInputs = globalBuildInputs;
    meta = {
      description = "Micro-services deployment client";
      homepage = https://stash.atlassian.com/projects/MICROS/repos/micros-cli;
      license = "UNLICENSED";
    };
    production = true;
  };
in
{
  tarball = nodeEnv.buildNodeSourceDist args;
  package = nodeEnv.buildNodePackage args;
  shell = nodeEnv.buildNodeShell args;
}
