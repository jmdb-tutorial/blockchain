(ns bigchaindb.core
  (:require [clj-http.client :as http]
            [cheshire.core :refer :all :as json]))

(defn submit-tx [server tx]
  (http/post (str (:api-base-path server) "transactions/")
             {:throw-exceptions false
              :content-type :json
              :accept :json
              :body "foo"}))
