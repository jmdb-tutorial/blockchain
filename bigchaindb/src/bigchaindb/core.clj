(ns bigchaindb.core
  (:require [clj-http.client :as http]
            [cheshire.core :refer :all :as json]
            [clojure.string :as string]))

(defn response-line [response]
  (let [protocol-version (:protocol-version response)
        protocol-name (:name protocol-version)
        major (:major protocol-version)
        minor (:minor protocol-version)
        reason-phrase (string/capitalize (:reason-phrase response))
        status-code (:status response)]
    (str protocol-name "/" major "." minor " " status-code " " reason-phrase)) )

(def transaction-version 1) ;;"Currently this seems to be hardcoded - see https://github.com/bigchaindb/bigchaindb/blob/master/bigchaindb/util.py:298)"

(defn build-tx [operation payload]
  {:id "<hash of transaction, excluding signatures>"
   :version transaction-version
   :transaction {:fullfilments []
                 :conditions []
                 :operation (name operation)
                 :timestamp "<timestamp from client>"
                 :data {:hash "<hash of payload>"
                        :payload payload}}})

(defn submit-tx [server tx]
  (let [request-url (str (:api-base-path server) "transactions/")
        json-body (json/generate-string tx)
        response  (http/post request-url
                             {:throw-exceptions false
                              :content-type :json
                              :accept :json
                              :body json-body
                              :socket-timeout 5000 
                              :conn-timeout 1000} )]
    (println "POST" request-url "HTTP/1.1")
    (println json-body)
    (println (response-line response))
    (println (:body response))
   ;; (println response)
    
    response))
