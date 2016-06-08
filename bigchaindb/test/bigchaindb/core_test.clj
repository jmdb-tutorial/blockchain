(ns bigchaindb.core-test
  (:use midje.sweet)
  (:use [bigchaindb.core])
  (:require [cheshire.core :refer :all :as json]))

(def server {:api-base-path "http://bigchaindb.local:59984/api/v1/"})



(facts "Building a JSON string"
       (fact "simple string"
             (json/generate-string {:foo 20}) => "{\"foo\":20}"))

(facts "Build a CREATE transaction"
       (let [tx (build-tx :CREATE {:foo "bar" :oof "rab"})]
         (fact "transaction should be valid"
               (println (clojure.pprint/pprint  tx)))))

;; (facts "Posting a CREATE transaction"
;;        (let [response (submit-tx server {:foo "bar"})]
;;          (fact "the response should be valid"               
;;                (:status response) => 200)))


