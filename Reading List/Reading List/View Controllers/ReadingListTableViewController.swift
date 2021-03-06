//
//  ReadingListTableViewController.swift
//  Reading List
//
//  Created by Harmony Radley on 2/25/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class ReadingListTableViewController: UITableViewController, BookTableViewCellDelegate {
    
    
    var bookController = BookController()
    
    var delegate: BookTableViewCellDelegate?
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return bookController.readBooks.count
        } else if section == 1 {
            return bookController.unreadBooks.count
        }
        return 0
    }
    
    func bookFor(indexPath: IndexPath) -> Book {
        let section = indexPath.section
        if section == 0 {
            return bookController.readBooks[indexPath.row]
        } else {
            return bookController.unreadBooks[indexPath.row]
        }
    }
    
    func toggleHasBeenRead(for cell: BookTableViewCell) {
        
        if let book = cell.book {
            bookController.updateHasBeenRead(for: book)
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as? BookTableViewCell else { return UITableViewCell() }
        
        let book = bookFor(indexPath: indexPath)
        cell.book = book
        cell.delegate = self
        
        return cell
        
        }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            if section == 0 {
                return "Read Books"
            } else {
                return "Unread Books"
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let book = bookFor(indexPath: indexPath)
            bookController.deleteBook(book: book)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addBookSegue" {
            if let destinationVC = segue.destination as? BookDetailViewController {
                destinationVC.bookController = bookController
            }
        }
        
        if segue.identifier == "BookDetail" {
            if let destinationVC = segue.destination as? BookDetailViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let book = bookFor(indexPath: indexPath)
                    destinationVC.bookController = bookController
                    destinationVC.book = book
                }
            }
        }
    }
    
    
}

