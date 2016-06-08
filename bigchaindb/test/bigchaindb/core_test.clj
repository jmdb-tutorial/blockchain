(ns bigchaindb.core-test
  (:use midje.sweet)
  (:use [bigchaindb.core])
  (:require [cheshire.core :refer :all :as json]))

(def server {:api-base-path "http://bigchaindb.local:59984/api/v1/"})

(facts "Building a JSON string"
       (fact "simple string"
             (json/generate-string {:foo 20}) => "{\"foo\":20}"))

(facts "Posting a CREATE transaction"
       (let [response (submit-tx server {})]
         (fact "the response should be valid"
               (println response)
               (:status response) => 200)))

