//
//  ViewController.swift
//  MyOkashi
//
//  Created by user on 2022/12/05.
//

import UIKit
import SafariServices

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, SFSafariViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchText.delegate = self
        searchText.placeholder = "キーワードを入力してください"
        searchOkashi(keyword: "")

        tableView.dataSource = self
        tableView.delegate = self
    }


    @IBOutlet weak var searchText: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    var okashiList : [(title: String, description: String, link: URL, pubDate: String)]=[]
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        view.endEditing(true)
        
        if let searchWord = searchBar.text{
            print("search: ",searchWord)
            searchOkashi(keyword: searchWord)
        }
    }
        
    struct ItemJson: Codable {
        let title: String?
        let description: String?
        let link: URL?
        let category: String?
        let pubDate: String?
    }
    
    struct ResultJson: Codable{
        let items:[ItemJson]?
    }
    
    func searchOkashi (keyword : String){
        
        let rss_url = "https://global.toyota/export/jp/allnews_rss.xml"
        
        guard let req_url = URL(string: "https://api.rss2json.com/v1/api.json?rss_url=\(rss_url)") else{
            return
        }

        let req = URLRequest(url: req_url)
        let session = URLSession(configuration: .default, delegate:  nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: req, completionHandler: {
            (data, response, error) in
            session.finishTasksAndInvalidate()
            
            do{
                let decoder = JSONDecoder()
                let json = try decoder.decode(ResultJson.self, from: data!)
                if let items = json.items {
                    self.okashiList.removeAll()
                    for item in items {
                        guard let title = item.title else {
                            return
                        }
                        guard let description = item.description else {
                            return
                        }
                        guard let link = item.link else {
                            return
                        }
//                        guard let category = item.category else {
//                            return
//                        }
                        guard let pubDate = item.pubDate else {
                            return
                        }

                        let okashi = (title, description, link, pubDate)
                        self.okashiList.append(okashi)
                    }
//                    print(self.okashiList.filter{$0.title == "プリウス"})
                }
//                print(self.okashiList)
                    
                self.tableView.reloadData()
                
                print("NoOfRecords: ", self.okashiList.count)
//                var filteredList = [(self.title, self.description, link)]
//                filteredList = self.okashiList.filter{$0.title == "プリウス"}

//                if let okashidbg = self.okashiList.first{
//                    print("----")
//                    print("okashiList[0] \(okashidbg)")
//                }
                
            } catch{
                
                print("Error!")
            }
        })
        
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return okashiList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "okashiCell", for: indexPath)

        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "okashiCell", for: indexPath) as? TopicsTableViewCell else {
            fatalError("Dequeue failed: topicTableViewCell.")
        }
        
        cell.title.text = okashiList[indexPath.row].title
        cell.pubDate.text = okashiList[indexPath.row].pubDate
        cell.detail.text = okashiList[indexPath.row].description
                                        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        
        let safariViewController = SFSafariViewController(url: okashiList[indexPath.row].link)
        
        safariViewController.delegate = self

        present(safariViewController, animated: true, completion: nil)
        
        func safariVewControllerDidFinish(_ controller: SFSafariViewController){
            dismiss(animated: true, completion: nil)
        }
    }
        
}
