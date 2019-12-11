
abstract class CrudRepository<T> {

  T findById(int id);

  List<T> findAll();

  void save(T entity);

  void saveAll(List<T> entities);

  void delete(T entity);

  void deleteAll(List<T> entities);

  void deleteById(int id);
  
}