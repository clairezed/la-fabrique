# Useful links gathered for further improvements or developments of this app

## Server config
- ssl 

## Improving performance
- gem checking n+1, etc (bullet ?)
- monit on serveur
- cloudflare
- aws

Articles : 

- https://hackhands.com/ruby-rails-performance-tuning/ (2014)
- https://infinum.co/the-capsized-eight/top-8-tools-for-ruby-on-rails-code-optimization-and-cleanup



### Non-evil optimization (http://blog.scoutapp.com/articles/2016/05/09/rails-performance-and-the-root-of-all-evil)
- Ensuring that a popular action stays under 300ms for 95% of users
- Implementing caching for a page that is hit often and doesn't change regularly
- Increasing RAM as your database grows in size
- Ensuring that Rails instances stay at 50-70% capacity, so you have headroom for a traffic spike
- When expanding or adding features, evaluating the performance of the existing feature to see if it needs cleanup/refactoring first
- Monitoring your app regularly and fixing low hanging fruit like n+1s, lack of pagination, etc.


### Todo 

- tests ?

#### Tools

- state = accepted when by_admin
- soumis par : niet quand par admin
- mail notification nl outil / commentaire
- clean code admin ajax quand ce sera sûr que formulaire 2 étapes
- revoir champs obligatoires et nom des champs

#### Hosting

- destroy old releases ?