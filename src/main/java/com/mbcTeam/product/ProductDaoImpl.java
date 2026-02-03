package com.mbcTeam.product;

import java.util.List;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.mbcTeam.user.ReviewVO;

@Repository
public class ProductDaoImpl implements ProductDao {

	@Autowired
	private SqlSessionTemplate mybatis;

	@Override
	public void insert(ProductVO vo) {
		mybatis.insert("PRODUCT.INSERT_PRODUCT", vo);
	}

	@Override
	public void insertImg(ProductImgVO ivo) {
		mybatis.insert("PRODUCT.INSERT_PRODUCT_IMG", ivo);
	}

	@Override
	public void insertDescImg(ProductDescImgVO divo) {
		mybatis.insert("INSERT_PRODUCT_DESC_IMG", divo);
	}

	@Override
	public void insertOption(ProductOptionVO ovo) {
		mybatis.insert("PRODUCT.INSERT_PRODUCT_OPTION", ovo);
	}

	@Override
	public void update(ProductVO vo) {
		mybatis.update("PRODUCT.UPDATE_PRODUCT", vo);
	}

	@Override
	public void delete(ProductVO vo) {
		mybatis.delete("PRODUCT.DELETE_PRODUCT", vo);
	}

	@Override
	public List<ProductVO> select(ProductVO vo) {
		return mybatis.selectList("PRODUCT.SELECT_PRODUCT_LIST", vo);
	}

	@Override
	public ProductVO edit(ProductVO vo) {
		return mybatis.selectOne("PRODUCT.SELECT_PRODUCT_DETAIL_ADMIN", vo);
	}

	@Override
	public ProductVO detail(int productIdx) {
		return mybatis.selectOne("PRODUCT.SELECT_PRODUCT_DETAIL_USER", productIdx);
	}

	@Override
	public List<ProductOptionVO> selectOptions(int productIdx) {
		return mybatis.selectList("PRODUCT.SELECT_PRODUCT_OPTIONS", productIdx);
	}

	@Override
	public List<ReviewVO> selectReviews(int productIdx) {
		return mybatis.selectList("PRODUCT.SELECT_PRODUCT_REVIEWS", productIdx);
	}

	@Override
	public List<ProductVO> selectAll() {
		return mybatis.selectList("PRODUCT.SELECT_ALL_PRODUCTS");
	}

	@Override
	public List<ProductVO> selectByCategory(String category) {
		return mybatis.selectList("PRODUCT.SELECT_BY_CATEGORY", category);
	}

	@Override
	public int totalCount(ProductVO vo) {
		return mybatis.selectOne("PRODUCT.TOTAL_COUNT", vo);
	}

	@Override
	public List<ProductVO> adminSelect(ProductVO vo) {
		return mybatis.selectList("SELECT_ADMIN_PRODUCT_LIST", vo);
	}
}
