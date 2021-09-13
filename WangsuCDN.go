package main

import (
	"crypto/hmac"
	"crypto/sha1"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"strings"
	"time"
)

func Sha1(apikey ,nowtime string) string {
	hmac := hmac.New(sha1.New, []byte(apikey))
	hmac.Write([]byte(nowtime))
	return base64.StdEncoding.EncodeToString(hmac.Sum(nil))
}

func WangSuCDNpreu(){
	client := &http.Client{}
	var values map[string]string
	values = make(map[string]string)
	values["Content-type"]="application/json"
	values["Date"]=time.Now().UTC().Format(http.TimeFormat)
	var values1 map[string]interface{}
	values1 = make(map[string]interface{})
	values1["dirs"]=[]string{"https://网宿域名/"}
	token :=Sha1("网宿的apikey",time.Now().UTC().Format(http.TimeFormat))

	js,_ := json.Marshal(values1)
	urls :="https://open.chinanetcenter.com/ccm/purge/ItemIdReceiver"
	req,_ := http.NewRequest("POST",urls,strings.NewReader(string(js)))

	for key,value := range values {
		req.Header.Add(key,value)
	}
	req.SetBasicAuth("网宿用户",token)
	resp, err := client.Do(req)
	defer resp.Body.Close()
	content, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("Fatal error ", err.Error())
	}

	fmt.Println(string(content))
}
func main() {
	WangSuCDNpreu()
}
