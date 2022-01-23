package main

import (
	"crypto/hmac"
	"crypto/sha1"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"github.com/mkideal/cli"
	"io/ioutil"
	"net/http"
	"os"
	"strings"
	"time"
)

func Sha1(apikey ,nowtime string) string {
	hmac := hmac.New(sha1.New, []byte(apikey))
	hmac.Write([]byte(nowtime))
	return base64.StdEncoding.EncodeToString(hmac.Sum(nil))
}

func WangSuCDNpreu(domain,username,apikey string){
	client := &http.Client{}
	var values map[string]string
	values = make(map[string]string)
	values["Content-type"]="application/json"
	values["Date"]=time.Now().UTC().Format(http.TimeFormat)
	var values1 map[string]interface{}
	values1 = make(map[string]interface{})
	values1["dirs"]=[]string{"https://"+domain+"/"}
	token :=Sha1(apikey,time.Now().UTC().Format(http.TimeFormat))

	js,_ := json.Marshal(values1)
	urls :="https://open.chinanetcenter.com/ccm/purge/ItemIdReceiver"
	req,_ := http.NewRequest("POST",urls,strings.NewReader(string(js)))

	for key,value := range values {
		req.Header.Add(key,value)
	}
	req.SetBasicAuth(username,token)
	resp, err := client.Do(req)
	defer resp.Body.Close()
	content, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("Fatal error ", err.Error())
	}

	fmt.Println(string(content))
}
type argT struct {
	cli.Helper
	Domain string `cli:"d,domain" usage:"输入网宿刷新的域名"`
	Apikey string  `cli:"k,apikey" usage:"输入网宿apikey"`
	Username string  `cli:"u,username" usage:"输入网宿的账号名称"`
}

func main() {
	os.Exit(cli.Run(new(argT), func(ctx *cli.Context) error {
		argv := ctx.Argv().(*argT)
		ctx.String("domain=%s, apikey=%s, username=%s\n", argv.Domain, argv.Apikey, argv.Username)
		fmt.Println("刷新的域名为： "+argv.Domain+"刷新的网宿账号为：" +argv.Username)
		WangSuCDNpreu(argv.Domain,argv.Username,argv.Apikey)
		return nil
	}))
}
