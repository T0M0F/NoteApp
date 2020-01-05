
abstract class CrudRepository<T> {

  Future<T> findById(int id);

  Future<List<T>> findAll();

  void save(T entity);

  void saveAll(List<T> entities);

  void delete(T entity);

  void deleteAll(List<T> entities);

  void deleteById(int id);
  
}